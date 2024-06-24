//
//  SSLPinningSecureURLSession.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation

class SSLPinningSecureURLSession {
    
    // MARK: - Variables
    let session: URLSession
    
    // MARK: - Initializers
    init() {
        session = URLSession(
            configuration: .ephemeral,
            delegate: SSLPinningDelegate(),
            delegateQueue: nil)
    }
}

//MARK: - URLSession extension: shared
extension URLSession {
    static var shared: URLSession {
        return SSLPinningSecureURLSession().session
    }
}
