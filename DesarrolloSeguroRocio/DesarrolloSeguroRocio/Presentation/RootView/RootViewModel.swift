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
     
     func authenticateUser(completion: @escaping (Bool) -> Void) {
         let context = LAContext()
         var error: NSError?
         
         if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
             let reason = "Identifícate para acceder a la aplicación"
             context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                 DispatchQueue.main.async {
                     completion(success)
                 }
             }
         } else {
             completion(false)
         }
     }
     
    func fetchPokemon(name: String, completion: @escaping ([Pokemon]?) -> Void) async {
        self.status = .loading
        do {
            let pokemonList = try await repository.getPokemonList()
            DispatchQueue.main.async {
                self.status = .loaded
                completion(pokemonList)
            }
        } catch {
            print("Error while fetching Pokémon: \(error)")
            DispatchQueue.main.async {
                self.status = .none
                completion(nil)
            }
        }
    }
 }
