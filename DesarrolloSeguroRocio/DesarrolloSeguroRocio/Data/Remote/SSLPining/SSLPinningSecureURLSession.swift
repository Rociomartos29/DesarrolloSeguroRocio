//
//  SSLPinningSecureURLSession.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
class SSLPinningSecureURLSession {
    
    let session: URLSession
    
    init() {
        let expectedPublicKey = "XM/zPZlyGRsb47ZGBJvaZGYVjQvjOrF6u5A5sxyDakk=" 
        let sslPinningDelegate = SSLPinningDelegate(expectedPublicKey: expectedPublicKey)
        session = URLSession(
            configuration: .ephemeral,
            delegate: sslPinningDelegate,
            delegateQueue: nil)
    }
}
