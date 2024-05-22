//
//  PokemonViewModel.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation

class PokemonViewModel: ObservableObject {
    @Published var pokemonList: [Pokemon] = []
    @Published var isLoading: Bool = false
    @Published var selectedPokemonDetail: PokemonDetail?
    @Published var nextPageURL: String?
    @Published var pokemonCompuestoList: [PokemonCompuesto] = []
    
    private let remoteDataSource: RemoteDataSourceProtocol // Inyectar el RemoteDataSource
    
    init(remoteDataSource: RemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchPokemonList() {
        isLoading = true
        
        Task {
            do {
                let pokemonListResponse = try await remoteDataSource.getPokemonList()
                let newPokemonCompuestos = try await createPokemonCompuestos(from: pokemonListResponse.results)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.pokemonCompuestoList = newPokemonCompuestos
                }
            } catch {
                print("Error while fetching Pokémon: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func createPokemonCompuestos(from pokemonResults: [PokemonResult]) async throws -> [PokemonCompuesto] {
        var pokemonCompuestos: [PokemonCompuesto] = []
        for pokemonResult in pokemonResults {
            let pokemon = Pokemon(name: pokemonResult.name, url: "\(pokemonResult.url)")
            do {
                let pokemonDetail = try await remoteDataSource.getPokemonDetailRequest(for: pokemon)
                let pokemonCompuesto = PokemonCompuesto(pokemon: pokemon, pokemonDetail: pokemonDetail!)
                pokemonCompuestos.append(pokemonCompuesto)
            } catch {
                throw error
            }
        }
        return pokemonCompuestos
    }
    
    func fetchPokemonDetail(pokemon: Pokemon) async {
        do {
            let pokemonDetail = try await remoteDataSource.getPokemonDetailRequest(for: pokemon)
            self.selectedPokemonDetail = pokemonDetail
        } catch {
            print("Error fetching Pokemon detail: \(error)")
        }
    }
}
