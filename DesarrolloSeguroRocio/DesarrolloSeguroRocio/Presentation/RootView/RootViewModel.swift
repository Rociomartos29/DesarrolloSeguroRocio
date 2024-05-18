//
//  RootViewModel.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
import LocalAuthentication

enum Status {
    case none, loading, loaded
}

enum LoginError {
    case authenticationError
    case serverError
    case unknownError
    case none
}

final class RootViewModel: ObservableObject {
    
    // MARK: Properties
    let repository: RepositoryProtocol
    @Published var status = Status.none
    let authentication: Authentication
    
    // MARK: Init
    init(repository: RepositoryProtocol) {
        self.repository = repository
        self.authentication = Authentication(context: LAContext())
    }
    
    // MARK: Functions
    
    
    func fetchPokemon(name: String, completion: @escaping (Pokemon?) -> Void) async {
        self.status = .loading
        do {
            let pokemon = try await repository.getPokemon(name: name)
            DispatchQueue.main.async {
                self.status = .loaded
                completion(pokemon)
            }
        } catch {
            print("Error while fetching Pokémon: \(error)")
            DispatchQueue.main.async {
                self.status = .none
                completion(nil)
            }
        }
    }
    
    func onPasswordFieldClick(withUser user: String, completion: @escaping (String) -> Void) {
        guard KeychainHelper.keychain.readUser() == user else {
            print("The user for which the password request was made is not in the keychain")
            completion("")
            return
        }
        // Comprobar si existe una contraseña almacenada en keychain
        guard let password = KeychainHelper.keychain.readPasswordWithAuthentication(authentication: self.authentication) else {
            print("Error: could not read password from keychain")
            completion("")
            return
        }
        completion(password)
    }
}
