//
//  EditCategoryView.swift
//  PruebaTecnica
//
//  Created by Wiliam Ochoa on 31/08/23.
//

import SwiftUI

struct EditCategoryView: View {
    @Binding var category: Categoria? // La categoría a editar
    @Binding var editedName: String // El nombre editado
    @Binding var isPresented: Bool // Estado que controla si se muestra la vista
    var onUpdate: () -> Void // Función de actualización a ejecutar cuando se guarda

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Editar Categoría")) {
                    TextField("Nuevo nombre", text: $editedName)
                }
            }
            .navigationBarTitle(Text("Editar Categoría"), displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancelar") {
                    isPresented = false // Cierra la vista de edición
                },
                trailing: Button("Guardar") {
                    if var category = category {
                        category.nombre = editedName // Actualiza el nombre de la categoría
                        onUpdate() // Llama a la función de actualización proporcionada
                    }
                    isPresented = false // Cierra la vista de edición después de guardar
                }
                .disabled(editedName.isEmpty) // El botón de guardar se deshabilita si el nombre está vacío
            )
        }
    }
}
