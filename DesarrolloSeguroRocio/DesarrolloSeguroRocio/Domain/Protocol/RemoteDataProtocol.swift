//
//  RemoteDataProtocol.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
protocol RemoteDataSourceProtocol {
    func getPokemonList() async throws -> PokemonListResponse
    func getPokemonDetailRequest(for pokemon: Pokemon) async throws -> PokemonDetail?
}
