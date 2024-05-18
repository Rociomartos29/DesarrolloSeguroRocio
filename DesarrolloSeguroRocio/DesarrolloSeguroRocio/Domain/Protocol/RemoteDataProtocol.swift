//
//  RemoteDataProtocol.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
protocol RemoteDataSourceProtocol {
    var urlRequestHelper: URLRequestHelperProtocol { get }
    func getPokemon(name: String) async throws -> Pokemon?
}
