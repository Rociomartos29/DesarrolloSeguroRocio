//
//  PokemonViewModel.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation

class PokemonListViewModel: ObservableObject {
    @Published var pokemonList: [Pokemon] = []
    @Published var isLoading: Bool = false
    @Published var imageData: [URL: Data] = [:]
    
    func fetchPokemonList() {
        isLoading = true
        
        guard let url = URL(string: "\(Endpoints().baseURL)\(Endpoints().pokemonEndpoint)") else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                guard let data = data, error == nil else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let pokemonListResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                    self.pokemonList = pokemonListResponse.results
 
                } catch {
                    print("Error decoding JSON data: \(error.localizedDescription)")
                    if let jsonDataString = String(data: data, encoding: .utf8) {
                        print("JSON data received: \(jsonDataString)")
                    } else {
                        print("Unable to convert data to string")
                    }
                }
            }
        }
        
        task.resume()
    }
}
