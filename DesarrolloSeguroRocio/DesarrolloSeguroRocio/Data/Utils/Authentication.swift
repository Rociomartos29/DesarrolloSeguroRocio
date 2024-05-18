//
//  Authentication.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
import LocalAuthentication

class Authentication {
    
    // MARK: Properties
    let context: LAContext
    private var error: NSError?
    
    // MARK: Init
    init(context: LAContext) {
        self.context = context
    }
    
    // MARK: Methods
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Identifícate para acceder a la aplicación"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
    
    func getAccessControl() -> SecAccessControl? {
        var accessControlError: Unmanaged<CFError>?
        guard let accessControl = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .userPresence, &accessControlError) else {
            print("Error: could not create access control with error \(String(describing: accessControlError))")
            return nil
        }
        return accessControl
    }
}
