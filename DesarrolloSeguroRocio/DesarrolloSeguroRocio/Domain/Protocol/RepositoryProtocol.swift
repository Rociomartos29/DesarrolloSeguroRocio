//
//  RepositoryProtocol.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
protocol RepositoryProtocol {
    var remoteDataSource: RemoteDataSourceProtocol { get }

    func getPokemon(name: String) async throws -> Pokemon?
}
