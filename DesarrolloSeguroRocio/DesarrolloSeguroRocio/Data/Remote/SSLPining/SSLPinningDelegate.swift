//
//  SSLPinningDelegate.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
import CommonCrypto
import CryptoKit

class SSLPinningDelegate: NSObject {
    
    // MARK: - Properties
        private let expectedPublicKey: String
            
        // Inicializador que toma la clave pública esperada como parámetro
        init(expectedPublicKey: String) {
            self.expectedPublicKey = expectedPublicKey
            super.init()
        }

        // Función para comparar las claves públicas
        private func publicKeyMatchesExpected(_ serverPublicKey: SecKey) -> Bool {
            // Transforma la clave pública del servidor a datos
            guard let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil) as Data? else {
                print("SSLPinning error: unable to convert server public key to data")
                return false
            }
            
            // Aplica el hash SHA256 a la clave pública del servidor
            let serverPublicKeyHash = sha256CryptoKit(data: serverPublicKeyData)
            
            // Imprime el hash de la clave pública del servidor
            print("Server public key hash: \(serverPublicKeyHash)")
            
            // Clave pública esperada (debes reemplazar esto con el hash de la clave pública esperada)
            let expectedPublicKeyHash = obfuscateURL(url: expectedPublicKey)
            
            // Compara el hash de la clave pública del servidor con el hash de la clave pública esperada
            return serverPublicKeyHash == expectedPublicKeyHash
        }
    }

    extension SSLPinningDelegate: URLSessionDelegate {
        
        public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            // Get the server trust
            guard let serverTrust = challenge.protectionSpace.serverTrust else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                print("SSLPinning error: server didn't present trust")
                return
            }
            
            // Get the public key of the server's certificate
            guard let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                print("SSLPinning error: failed to get server certificate")
                return
            }
            
            // Get the public key of the server certificate
            guard let serverPublicKey = SecCertificateCopyKey(serverCertificate) else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                print("SSLPinning error: failed to get server public key")
                return
            }
            
            // Transform the public key to data
            guard let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil) as Data? else {
                print("SSLPinning error: unable to convert server public key to data")
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            
            // SHA256 hash of the server's public key
            let serverPublicKeyHash = sha256CryptoKit(data: serverPublicKeyData)
            
            // Print the server's public key hash
            print("Server public key hash: \(serverPublicKeyHash)")
            
            // Expected public key hash (you should replace this with your expected public key hash)
            let expectedPublicKeyHash = obfuscateURL(url: expectedPublicKey)
            
            // Compare the server's public key hash with the expected public key hash
            if serverPublicKeyHash == expectedPublicKeyHash {
                // Server's public key matches the expected public key
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                print("SSLPinning filter passed")
            } else {
                // Server's public key does not match the expected public key
                print("SSLPinning error: server public key doesn't match expected public key")
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
    }

    //MARK: - SSLPinning extension: SHA
    extension SSLPinningDelegate {
        
        /// Create a SHA256 representation of the data passed as parameter (common crypto)
        private func sha256(data: Data) -> String {
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            data.withUnsafeBytes { bufferPointer in
                _ = CC_SHA256(bufferPointer.baseAddress, CC_LONG(bufferPointer.count), &hash)
            }
            return Data(hash).base64EncodedString()
        }
        
        /// Create a SHA256 representation of the data passed as parameter (crypto kit)
        private func sha256CryptoKit(data: Data) -> String {
            let hash = SHA256.hash(data: data)
            return Data(hash).base64EncodedString()
        }
        
        /// Obfuscate the URL
        func obfuscateURL(url: String) -> String {
            let hash = SHA256.hash(data: Data(url.utf8))
            let hashedString = hash.compactMap { String(format: "%02x", $0) }.joined()
            return hashedString
        }

        // Función de desofuscación
        private func deobfuscateURL(obfuscatedURL: String) -> String {
            return String(obfuscatedURL.reversed())
        }
    }
