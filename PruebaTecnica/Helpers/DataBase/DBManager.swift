//
//  DBManager.swift
//  PruebaTecnica
//
//  Created by Wiliam Ochoa on 29/08/23.
//

import Foundation
import SQLite

class DBManager : ObservableObject{
    static let shared = DBManager() // Singleton para facilitar el acceso
    private var db: Connection? = nil

    private init() {
        openDatabase()
        createTable()
        setDefaultCategories()
    }

    private func openDatabase() {
        do {
            let dbPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("miBaseDeDatos.sqlite3").path

            db = try Connection(dbPath)
            print("Base de datos abierta correctamente en \(dbPath)")
        } catch {
            print("Error al abrir la base de datos: \(error)")
            // manejar el error de apertura
        }
    }

    private func createTable() {
        let categorias = Table("categorias")
        let id = Expression<Int>("id")
        let nombre = Expression<String>("nombre")

        do {
            try db?.run(categorias.create { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(nombre)
            })
            print("Tabla 'categorias' creada correctamente")
        } catch {
            print("Error al crear la tabla: \(error)")
            // manejar el error de creación de tabla
        }
    }

    private func insertCategory(name: String) {
        let categorias = Table("categorias")
        let nombre = Expression<String>("nombre")

        do {
            let insert = categorias.insert(nombre <- name)
            let rowID = try db?.run(insert)
            if rowID != nil {
                print("Categoría insertada correctamente: \(name)")
            } else {
                print("Error al insertar categoría")
                // manejar el error de inserción
            }
        } catch {
            print("Error al preparar la consulta de inserción: \(error)")
            // manejar el error de preparación de consulta
        }
    }

    func getCategorias() -> [Categoria] {
        let categorias = Table("categorias")
        let id = Expression<Int>("id")
        let nombre = Expression<String>("nombre")

        do {
            let query = categorias.select(id, nombre)
            let results = try db?.prepare(query)

            var categories: [Categoria] = []
            for row in results! {
                let id = row[id]
                let nombre = row[nombre]
                categories.append(Categoria(id: id, nombre: nombre))
            }

            return categories
        } catch {
            print("Error al consultar datos: \(error)")
            // Puedes manejar el error de consulta aquí según tus necesidades
            return []
        }
    }

    func deleteTable() {
        let categorias = Table("categorias")
        do {
            try db?.run(categorias.delete())
            print("Tabla 'categorias' eliminada correctamente")
        } catch {
            print("Error al eliminar la tabla: \(error)")
            // manejar el error de eliminación
        }
    }

    private func setDefaultCategories() {
        let categories: [String] = ["mexico", "videogames"]
        if getCategorias().isEmpty { // si no tiene registros se insertaran 2 categorias
            categories.forEach { category in
                insertCategory(name: category)
            }
        }
    }
}
