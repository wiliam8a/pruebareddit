import Foundation
import SQLite
import Combine 

class DBManager: ObservableObject { // Marcamos la clase como ObservableObject
    
    static let shared = DBManager()// Singleton para facilitar el acceso
    @Published var categories: [Categoria] = [] // @Published se utiliza para crear una propiedad observable
    private var db: Connection? = nil

    private init() {
        openDatabase()
        createTable()
        setDefaultCategories()
        loadCategories()
    }

    // MARK: - Base de Datos
    
    private func openDatabase() {
        // Abre la base de datos SQLite en el directorio de documentos
        do {
            let dbPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("miBaseDeDatos.sqlite3").path
            db = try Connection(dbPath)
            print("Base de datos abierta correctamente en \(dbPath)")
        } catch {
            print("Error al abrir la base de datos: \(error)")
            // Manejar el error de apertura
        }
    }

    private func createTable() {
        // Crea la tabla 'categorias' en la base de datos
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
            // Manejar el error de creación de tabla
        }
    }

    // MARK: - Categorías
    
    private func loadCategories() {
        // Carga las categorías desde la base de datos
        let categorias = Table("categorias")
        let id = Expression<Int>("id")
        let nombre = Expression<String>("nombre")

        do {
            let query = categorias.select(id, nombre)
            let loadedCategories = try db?.prepare(query).map { row in
                Categoria(id: row[id], nombre: row[nombre])
            }
            categories = loadedCategories ?? []
            print("Categorías cargadas correctamente")
        } catch {
            print("Error al consultar datos: \(error)")
            // Puedes manejar el error de consulta aquí según tus necesidades
        }
    }

    func insertCategory(name: String) {
        // Inserta una nueva categoría en la base de datos
        let categorias = Table("categorias")
        let nombre = Expression<String>("nombre")

        do {
            let insert = categorias.insert(nombre <- name)
            let rowID = try db?.run(insert)
            if rowID != nil {
                print("Categoría insertada correctamente: \(name)")
                loadCategories()
            } else {
                print("Error al insertar categoría")
                // Manejar el error de inserción
            }
        } catch {
            print("Error al preparar la consulta de inserción: \(error)")
            // Manejar el error de preparación de consulta
        }
    }

    func getCategorias() -> [Categoria] {
        // Obtiene todas las categorías de la base de datos
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
        // Elimina la tabla 'categorias' de la base de datos
        let categorias = Table("categorias")
        do {
            try db?.run(categorias.delete())
            print("Tabla 'categorias' eliminada correctamente")
        } catch {
            print("Error al eliminar la tabla: \(error)")
            // Manejar el error de eliminación
        }
    }
    
    func updateCategory(category: Categoria, newName: String) {
        // Actualiza el nombre de una categoría
        let categorias = Table("categorias")
        let id = Expression<Int>("id")
        let nombre = Expression<String>("nombre")

        let categoryToUpdate = categorias.filter(id == category.id)

        do {
            try db?.run(categoryToUpdate.update(nombre <- newName))
            print("Categoría actualizada correctamente")
            
            // Actualiza la categoría en el arreglo local
            if let index = self.categories.firstIndex(where: { $0.id == category.id }) {
                self.categories[index].nombre = newName
            }
        } catch {
            print("Error al actualizar la categoría: \(error)")
            // Puedes manejar el error de actualización aquí según tus necesidades
        }
    }
    
    func deleteCategory(category: Categoria) {
        // Elimina una categoría de la base de datos
        let categorias = Table("categorias")
        let id = Expression<Int>("id")

        let categoryToDelete = categorias.filter(id == category.id)

        do {
            try db?.run(categoryToDelete.delete())
            print("Categoría eliminada correctamente")
        } catch {
            print("Error al eliminar la categoría: \(error)")
            // Puedes manejar el error de eliminación aquí según tus necesidades
        }
    }

    private func setDefaultCategories() {
        // Inserta categorías predeterminadas si no hay categorías en la base de datos
        let categories: [String] = ["mexico", "videogames"]
        if getCategorias().isEmpty {
            categories.forEach { category in
                insertCategory(name: category)
            }
        }
    }
}
