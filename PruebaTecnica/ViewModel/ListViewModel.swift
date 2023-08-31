//
//  ListViewModel.swift
//  PruebaTecnica
//
//  Created by Wiliam Ochoa on 29/08/23.
//

import Foundation

final class ListViewModel: ObservableObject {
    
    // Propiedades publicadas para observar cambios en las vistas
    @Published var listaReddit: [Child] = [] // Lista de elementos obtenidos de Reddit
    @Published var errorMessage: ErrorMessage? = nil // Mensaje de error en caso de falla
    @Published var error = false // Bandera para indicar si se produjo un error
    
    // Función para obtener datos de Reddit en función de una categoría
    func fetchData(categoria: String) {
        
        // Crear URL para la petición
        guard let url = URL(string: "http://reddit.com/r/\(categoria)/.json") else {
            fatalError("URL inválida") // En caso de una URL inválida, se lanza una fatalidad
        }

        // Crear URLRequest con el método HTTP GET
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Realizar una tarea de datos en segundo plano
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            DispatchQueue.main.async { // Cambiamos al hilo principal para realizar actualizaciones de la interfaz de usuario
                
                if let error = error {
                    // Manejar el error en caso de que ocurra una falla en la petición
                    print("Error en la petición: \(error)")
                    self?.error = true // Marcamos la bandera de error como verdadera
                } else {
                    if let data = data {
                        // Intentamos decodificar los datos en un modelo Reddit
                        if let redditData = try? JSONDecoder().decode(Reddit.self, from: data) {
                            print("Éxito en la decodificación de datos")
                            self?.listaReddit = redditData.data.children // Actualizamos la lista con los datos obtenidos
                            self?.errorMessage = nil // Reseteamos cualquier mensaje de error previo
                        } else if let errorResponse = try? JSONDecoder().decode(ErrorMessage.self, from: data) {
                            // Si no se pudo decodificar el modelo Reddit pero se obtuvo un mensaje de error
                            print("Mensaje de error recibido: \(errorResponse.message)")
                            self?.errorMessage = errorResponse // Actualizamos el mensaje de error
                        } else {
                            // Si no se pudo decodificar ni RedditData ni ErrorMessage, indicamos un error
                            print("No se pudo decodificar ni RedditData ni ErrorMessage")
                            self?.error = true // Marcamos la bandera de error como verdadera
                        }
                    }
                }
            }
        }.resume() // Reanudamos la tarea de descarga
    }
}
