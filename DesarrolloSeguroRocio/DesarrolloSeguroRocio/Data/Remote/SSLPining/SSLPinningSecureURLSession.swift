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
        let sslPinningDelegate = SSLPinningDelegate(expectedPublicKey: "d3ec0c587004f328b446195927dc6f56f32ebcc389bbec666bcfae7aca04be86")
        session = URLSession(
            configuration: .ephemeral,
            delegate: sslPinningDelegate,
            delegateQueue: nil)
    }
    
    func makeRequest(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }
}
