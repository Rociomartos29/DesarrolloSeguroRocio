//
//  RemoteData.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation

final class RemoteDataSource: RemoteDataSourceProtocol {
    
    // MARK: Properties
    var urlRequestHelper: URLRequestHelperProtocol
    
    // MARK: Init
    init(urlRequestHelper: URLRequestHelperProtocol) {
        self.urlRequestHelper = urlRequestHelper
    }
    
    // MARK: Functions
    
    
    func getPokemon(name: String) async throws -> Pokemon? {
        guard let request = urlRequestHelper.getPokemon(name: name) else {
            return nil
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let pokemon = try decoder.decode(Pokemon.self, from: data)
        
        return pokemon
    }
}
