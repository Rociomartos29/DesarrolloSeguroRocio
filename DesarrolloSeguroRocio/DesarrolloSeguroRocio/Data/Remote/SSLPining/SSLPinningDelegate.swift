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
    private let publicKey: String = "XM/zPZlyGRsb47ZGBJvaZGYVjQvjOrF6u5A5sxyDakk=" 
    private let certificatePinning: Bool
    
    // MARK: - Init
    override init() {
        self.certificatePinning = false
    }
}

extension SSLPinningDelegate: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        // Get the server trust
        guard let serverTrust = challenge.protectionSpace.serverTrust  else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server didn't present trust")
            return
        }

        let serverCertificates: [SecCertificate]?
        serverCertificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate]
       
        guard let serverCertificate = serverCertificates?.first else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server certificate is nil")
            return
        }
        
        if certificatePinning {

            let policies = NSMutableArray()
            let sslPolicy = SecPolicyCreateSSL(true, "pokeapi.co" as CFString)
            policies.add(sslPolicy)

            SecTrustSetPolicies(serverTrust, policies)

            let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
            
            
            let remoteCertificateData: NSData = SecCertificateCopyData(serverCertificate)
           
            guard let localCertificatePath = Bundle.main.path(forResource: "pokeapi.co", ofType: "cer"),
                  let localCertificateData = NSData(contentsOfFile: localCertificatePath) else {
                      completionHandler(.cancelAuthenticationChallenge, nil)
                      print("SSLPinning error: local certificate data not found")
                      return
                  }
            
           
            print(localCertificateData)
            print(remoteCertificateData)
            
           
            if isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data) {
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                print("SSLPinning filter passed")
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                print("SSLPinning error: server certificate doesn't match")
            }
            
        } else {
            guard let serverPublicKey = SecCertificateCopyKey(serverCertificate) else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                print("SSLPinning error: server public key is nil")
                return
            }
            
            guard let serverPublicKeyRep = SecKeyCopyExternalRepresentation(serverPublicKey, nil) else {
                print("SSLPinning error: unable to convert server public key to data")
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            let serverPublicKeyData: Data = serverPublicKeyRep as Data
            
            let serverHashKeyBase64 = sha256CryptoKit(data: serverPublicKeyData)

            print("Local key is \(self.publicKey)")
            print("Server key is \(serverHashKeyBase64)")

            if serverHashKeyBase64 == self.publicKey {

                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                print("SSLPinning filter passed")
            } else{

                print("SSLPinning error: server certificate doesn't match")
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
    }
}


//MARK: - SSLPinning extension: SHA
extension SSLPinningDelegate{
    private func sha256(data : Data) -> String{

        let dataToHash = Data(data)
        
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))

        dataToHash.withUnsafeBytes { bufferPointer in
            _ = CC_SHA256(bufferPointer.baseAddress, CC_LONG(bufferPointer.count), &hash)
        }

        return Data(hash).base64EncodedString()
    }
    

    private func sha256CryptoKit(data: Data) -> String {
        let hash = SHA256.hash(data: data)
        return Data(hash).base64EncodedString()
    }

}
