//
//  URLProtocol.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
protocol URLRequestHelperProtocol {
    func getPokemonListRequest() -> URLRequest? // Nueva función para obtener la solicitud de la lista de Pokémon
    func getPokemonDetailRequest(for pokemon: Pokemon) -> URLRequest? // Función para obtener la solicitud de detalles de Pokémon
}
