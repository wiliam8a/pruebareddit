//
//  ContentView.swift
//  PruebaTecnica
//
//  Created by Wiliam Ochoa on 29/08/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var dbManager = DBManager.shared
    @StateObject private var vm = ListViewModel()
    @State private var categories: [Categoria] = []
    @State private var selectedCategory = ""

        var body: some View {
            NavigationView {
                HStack {
                    VStack(alignment: .leading){
                        HStack{
                            Picker("Categorias", selection: $selectedCategory) {
                                ForEach(categories, id: \.nombre) { categoria in
                                    Text("\(categoria.nombre)")
                                }
                            }
                            Button("Consultar") {
                                vm.fetchData(categoria: selectedCategory)
                            }
                        }
                        
                        ZStack{
                            
                            List {
                                ForEach(vm.listaReddit, id: \.data.title) { child in
                                    ChildView(row: child)
                                        .listRowSeparator(.hidden)
                                }
                            }
                            .listStyle(.plain)
                            .navigationTitle("Prueba Técnica")
                        }
                    }
                    
                }
                .navigationBarTitle("Prueba Técnica")
                .onAppear() {
                    categories = dbManager.getCategorias()
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
