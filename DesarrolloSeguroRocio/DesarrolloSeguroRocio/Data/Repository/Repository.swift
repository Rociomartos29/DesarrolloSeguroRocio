//
//  Repository.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
final class RepositoryImpl: RepositoryProtocol {

    // MARK: Properties
    var remoteDataSource: RemoteDataSourceProtocol
    
    // MARK: Init
    init(remoteDataSource: RemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func getPokemon(name: String) async throws -> Pokemon? {
        return try await remoteDataSource.getPokemon(name: name)
    }
}
