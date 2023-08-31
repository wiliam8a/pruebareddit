//
//  CategoriesView.swift
//  PruebaTecnica
//
//  Created by Wiliam Ochoa on 31/08/23.
//

import SwiftUI

struct CategoriesView: View {
    @ObservedObject var dbManager = DBManager.shared
    @State private var isEditing = false
    @State private var editedCategoryName = ""
    @State private var selectedItem: Categoria? = nil
    @State private var showEditSheet = false
    @State private var showAddCategoryView = false
    @State private var showAlert = false

    var body: some View {
        VStack {
            List {
                ForEach(dbManager.categories, id: \.id) { categoria in
                    HStack {
                        Text(categoria.nombre)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .swipeActions {
                        if(categoria.nombre != "mexico" && categoria.nombre != "videogames") {
                            Button {
                                editedCategoryName = categoria.nombre
                                selectedItem = categoria
                                showEditSheet = true
                            } label: {
                                Label("Editar", systemImage: "pencil")
                            }
                            .tint(.yellow)
                            Button(role: .destructive) {
                                showAlert = true
                            } label: {
                                Label("Eliminar", systemImage: "trash")
                            }
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("¿Estás seguro de que quieres eliminar esta categoría?"),
                            message: Text("Esta acción no se puede deshacer."),
                            primaryButton: .default(Text("Cancelar")),
                            secondaryButton: .destructive(Text("Eliminar")) {
                                deleteCategory(category: categoria)
                            }
                        )
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Categorías")
        .toolbar {
            Button(action: {
                showAddCategoryView = true
            }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showAddCategoryView) {
            // Vista de agregar categoría
            AddCategoryView(dbManager: dbManager, isPresented: $showAddCategoryView)
        }
        .sheet(isPresented: $showEditSheet) {
            EditCategoryView(category: $selectedItem, editedName: $editedCategoryName, isPresented: $showEditSheet, onUpdate: {
                // Aquí actualizamos la categoría en la base de datos
                if let selectedCategory = selectedItem {
                    dbManager.updateCategory(category: selectedCategory, newName: editedCategoryName)
                    // También puedes actualizar la propiedad selectedItem si lo deseas
                }
            })
        }
    }

    func deleteCategory(category: Categoria) {
        if let index = dbManager.categories.firstIndex(of: category) {
            dbManager.categories.remove(at: index)
            dbManager.deleteCategory(category: category)
        }
    }
}




struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
