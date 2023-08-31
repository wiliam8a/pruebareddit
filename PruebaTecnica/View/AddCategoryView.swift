//
//  AddCategoryView.swift
//  PruebaTecnica
//
//  Created by Wiliam Ochoa on 31/08/23.
//

import SwiftUI

struct AddCategoryView: View {
    // Propiedades para manejar la presentación y el estado de la vista
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dbManager: DBManager
    @State private var categoryName = ""
    @State private var isNameEmpty = true // Inicialmente, el nombre está vacío y el botón está deshabilitado
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nueva Categoría")) {
                    TextField("Nombre de la categoría", text: $categoryName)
                        .onChange(of: categoryName) { newValue in
                            isNameEmpty = newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        }
                }
            }
            .navigationTitle("Agregar Categoría")
            .navigationBarItems(
                leading: Button("Cancelar") {
                    isPresented = false // Cerrar la vista al presionar "Cancelar"
                },
                trailing: Button("Guardar") {
                    if !isNameEmpty {
                        saveCategory() // Llamar a la función para guardar la categoría
                        isPresented = false // Cerrar la vista después de guardar
                    }
                }
                .disabled(isNameEmpty) // Debe deshabilitarse si el nombre está vacío
            )
        }
    }

    // Función para guardar una nueva categoría
    private func saveCategory() {
        if !categoryName.isEmpty {
            dbManager.insertCategory(name: categoryName) // Llamar al método para insertar la categoría en la base de datos
            presentationMode.wrappedValue.dismiss() // Cerrar la vista de manera programática
        }
    }
}
