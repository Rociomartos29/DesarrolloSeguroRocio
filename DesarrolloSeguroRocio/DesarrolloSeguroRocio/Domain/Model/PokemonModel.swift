//
//  PokemonModel.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
struct Pokemon: Codable, Identifiable {
    let name: String
    let url: URL
    
    var id: URL { url }
}

struct PokemonListResponse: Decodable {
    let results: [Pokemon]
}
enum LoginServerError {
    case authenticationError
    case serverError
    case unknownError
    case loginSuccess
}
