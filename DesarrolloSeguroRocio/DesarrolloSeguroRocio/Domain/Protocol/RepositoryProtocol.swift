//
//  RepositoryProtocol.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
protocol RepositoryProtocol {
    var remoteDataSource: RemoteDataSourceProtocol { get }
    func getPokemonList() async throws -> [Pokemon] // Nueva función para obtener la lista de Pokémon
}
