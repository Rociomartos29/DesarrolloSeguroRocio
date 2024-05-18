//
//  KeyChainHelper.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
import Security

final class KeychainHelper {
    
    // MARK: - Properties
    static let keychain = KeychainHelper()

    // MARK: - Init
    private init() {}
    
    // MARK: - Functions
    
    func saveUser(user: String) {
        guard let userData = user.data(using: .utf8) else {
            print("Error: could not convert user to data")
            return
        }
        save(data: userData, account: "user")
    }
    
    func readUser() -> String? {
        guard let userData = read(account: "user") else {
            print("Error: could not read user from keychain")
            return nil
        }
        return String(data: userData, encoding: .utf8)
    }
    
    func deleteUser() {
        delete(account: "user")
    }
    
    func saveToken(token: String) {
        guard let tokenData = token.data(using: .utf8) else {
            print("Error: could not convert token to data")
            return
        }
        save(data: tokenData, account: "token")
    }
    
    func readToken() -> String? {
        guard let tokenData = read(account: "token") else {
            print("Error: could not read token from keychain")
            return nil
        }
        return String(data: tokenData, encoding: .utf8)
    }
    
    func deleteToken() {
        delete(account: "token")
    }
    
    // MARK: - Generic functions
    private func save(data: Data, service: String = "POKEAPP", account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            let queryToUpdate = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            SecItemUpdate(queryToUpdate, attributesToUpdate)
        } else if status != errSecSuccess {
            print("Error: error adding item")
        }
    }
    
    private func read(service: String = "POKEAPP", account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return result as? Data
    }
    
    private func delete(service: String = "POKEAPP", account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        SecItemDelete(query)
    }
    
    // MARK: - Password functions
    func savePasswordWithAuthentication(password: String, service: String = "POKEAPP", account: String = "password", authentication: Authentication) {
        guard let passwordData = password.data(using: .utf8) else {
            print("Error: could not convert password to data")
            return
        }
        
        guard let accessControl = authentication.getAccessControl() else {
            print("Error: could not get access control")
            return
        }
        
        let query = [
            kSecValueData: passwordData,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccessControl: accessControl,
            kSecAttrAccount: account
        ] as CFDictionary
        
        SecItemAdd(query, nil)
    }
    
    func readPasswordWithAuthentication(service: String = "POKEAPP", account: String = "password", authentication: Authentication) -> String? {
        
        let context = authentication.context
        context.localizedReason = "Authenticate to read password"
        context.localizedFallbackTitle = "Use passcode"
        context.touchIDAuthenticationAllowableReuseDuration = 10
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecUseAuthenticationContext: context,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query, &result)
        
        guard status == errSecSuccess,
            let resultData = result as? Data
        else {
            print("Error: could not retrieve data from keychain")
            return nil
        }
        
        guard let password = String(data: resultData, encoding: .utf8) else {
            print("Error: could not convert data to string")
            return nil
        }
        
        return password
    }
    
    func deletePassword() {
        delete(account: "password")
    }
}
