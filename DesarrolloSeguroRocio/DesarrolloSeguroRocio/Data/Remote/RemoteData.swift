//
//  RemoteData.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation

final class RemoteDataSource: RemoteDataSourceProtocol {
    private let urlRequestHelper: URLRequestHelperProtocol
    
    init(urlRequestHelper: URLRequestHelperProtocol) {
        self.urlRequestHelper = urlRequestHelper
    }
    
    func getPokemonList() async throws -> PokemonListResponse {
        guard let request = urlRequestHelper.getPokemonListRequest() else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("Raw JSON data: \(String(data: data, encoding: .utf8) ?? "")")
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decodedData = try JSONDecoder().decode(PokemonListResponse.self, from: data)
          
            return decodedData
        } catch {
            print("Error while fetching Pokémon list: \(error)")
            throw error
        }
    }
    func getPokemonDetailRequest(for pokemon: Pokemon) async throws -> PokemonDetail? {
        guard let request = urlRequestHelper.getPokemonDetailRequest(for: pokemon) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            let pokemonDetail = try decoder.decode(PokemonDetail.self, from: data)
            
            return pokemonDetail
        } catch {
            print("Error while fetching Pokémon detail: \(error)")
            throw error
        }
    }
}
