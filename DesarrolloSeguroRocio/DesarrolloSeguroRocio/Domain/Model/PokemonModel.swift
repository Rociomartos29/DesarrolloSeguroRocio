//
//  PokemonModel.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
struct Pokemon: Identifiable, Codable {
    let id = UUID()
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}

struct PokemonDetail: Identifiable, Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let abilities: [Ability]
}

struct Sprites: Codable {
    let front_default: String?
}

struct Ability: Codable {
    let ability: AbilityDetail
    let is_hidden: Bool
    let slot: Int
}

struct AbilityDetail: Codable {
    let name: String
    let url: String
}

struct PokemonListResponse: Codable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [PokemonResult]
}

struct PokemonResult: Codable {
    let name: String
    let url: URL
}
struct PokemonCompuesto: Identifiable, Equatable {
    let id = UUID()
    let pokemon: Pokemon
    let pokemonDetail: PokemonDetail
    
    static func == (lhs: PokemonCompuesto, rhs: PokemonCompuesto) -> Bool {
        return lhs.id == rhs.id
    }
}
