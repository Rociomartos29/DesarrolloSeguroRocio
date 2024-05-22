//
//  URLRequestRemote.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
import CryptoKit
final class URLRequestHelperImpl: URLRequestHelperProtocol {
    private let obfuscatedURL: String

        init(obfuscatedURL: String) {
            self.obfuscatedURL = obfuscatedURL
        }

        func getPokemonListRequest() -> URLRequest? {
            guard let url = URL(string: obfuscatedURL) else {
                print("Error while creating URL from \(obfuscatedURL)")
                return nil
            }

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"

            return urlRequest
        }

        func getPokemonDetailRequest(for pokemon: Pokemon) -> URLRequest? {
            guard let url = URL(string: pokemon.url) else {
                return nil
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            return request
        }
    }
