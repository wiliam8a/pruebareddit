//
//  ListViewModel.swift
//  PruebaTecnica
//
//  Created by Wiliam Ochoa on 29/08/23.
//

import Foundation

final class ListViewModel : ObservableObject {
    
    @Published var listaReddit : [Child] = []
    @Published var error = false
    
    func fetchData (categoria: String) {
        // Crear url
        let url = URL(string: "http://reddit.com/r/\(categoria)/.json")
        guard let requestUrl = url else { fatalError() }

        // Crear urlrequest
        var request = URLRequest(url: requestUrl)

        // set metodo get
        request.httpMethod = "GET"

        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            DispatchQueue.main.async {
                if let error = error {
                    // manejar el error (mostrar la descripcion del error en un text o alert)
                } else {
                    if let data = data,
                       let lista = try? JSONDecoder().decode (Reddit.self, from: data) {
                        self?.listaReddit = lista.data.children
                        
                    } else {
                        // error al deserealizar (revisar los modelos)
                    }
                }
            }
            
        }.resume ()

    }
}
