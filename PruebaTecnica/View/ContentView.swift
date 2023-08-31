//
//  ContentView.swift
//  PruebaTecnica
//
//  Created by Wiliam Ochoa on 29/08/23.
//

import SwiftUI

struct ContentView: View {
    // Administrador de la base de datos compartido
    @StateObject var dbManager = DBManager.shared

    // ViewModel para obtener los datos de Reddit
    @StateObject private var vm = ListViewModel()

    // Lista de categorías cargadas desde la base de datos
    @State private var categories: [Categoria] = []

    // Categoría seleccionada en el Picker
    @State private var selectedCategory = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .center, spacing: 0) {
                        Text("Selecciona categoría:")
                            .font(.system(size: 15))
                        Picker("Categorias", selection: $selectedCategory) {
                            ForEach(categories, id: \.nombre) { categoria in
                                Text("\(categoria.nombre)")
                            }
                        }
                        .onChange(of: selectedCategory) { categoriaSeleccionada in
                            // Cuando se cambia la categoría seleccionada, se llama a esta función
                            vm.fetchData(categoria: categoriaSeleccionada)
                        }
                    }

                    Spacer()

                    NavigationLink(destination: CategoriesView()) {
                        // Enlace para acceder a la vista de categorías
                        Text("Categorías")
                    }
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Títulos: \(selectedCategory)")
                        .font(.system(size: 25, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, alignment: .center)

                    if (vm.errorMessage != nil) {
                        Spacer()
                        Text("No se encontró esa categoría")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                        Spacer()
                    } else {
                        if (vm.listaReddit.count == 0) {
                            Spacer()
                            Text("No se encontraron títulos")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                            Spacer()
                        } else {
                            // Lista de títulos obtenidos de Reddit
                            List {
                                ForEach(vm.listaReddit, id: \.data.title) { child in
                                    ChildView(row: child)
                                        .listRowSeparator(.hidden)
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                }
            }
            .padding()
            .navigationBarTitle("Prueba Técnica")

            .onAppear() {
                // Cuando aparece la vista, cargamos las categorías disponibles desde la base de datos
                categories = dbManager.getCategorias()

                // Establecemos la categoría seleccionada inicialmente como la primera de la lista
                selectedCategory = categories[0].nombre
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
