//
//  URLRequestRemote.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
final class URLRequestHelperImpl: URLRequestHelperProtocol {
    func getPokemon(name: String) -> URLRequest? {
        guard let url = URL(string: "\(Endpoints().baseURL)\(Endpoints().pokemonEndpoint)") else {
            
            print("Error while creating URL from \(Endpoints().baseURL)\(Endpoints().pokemonEndpoint)\(name)")
            return nil
        }
        print(url)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
}
