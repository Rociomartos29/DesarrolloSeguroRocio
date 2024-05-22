//
//  Repository.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
final class RepositoryImpl: RepositoryProtocol {
    var remoteDataSource: RemoteDataSourceProtocol
    
    init(remoteDataSource: RemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func getPokemonList() async throws -> [Pokemon] {
        let pokemonListResponse = try await remoteDataSource.getPokemonList()
        // Extraer los objetos Pokemon del PokemonListResponse
        let pokemonList = pokemonListResponse.results.map { pokemonResult in
            // Construir un objeto Pokemon a partir de PokemonResult
            return Pokemon(name: pokemonResult.name, url: "\(pokemonResult.url)")
        }
        return pokemonList
    }
}
