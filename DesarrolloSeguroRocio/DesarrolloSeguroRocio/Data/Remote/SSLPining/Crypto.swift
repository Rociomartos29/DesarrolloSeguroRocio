//
//  Crypto.swift
//  DesarrolloSeguroRocio
//
//  Created by Rocio Martos on 18/5/24.
//

import Foundation
import CryptoKit
enum AESKeySize: Int {
    case bits128 = 16
    case bits192 = 24
    case bits256 = 32
}

public class Crypto {
    // MARK: - Properties
    private let sealedDataBox = "rnYjGPQ9lyITegM6QusUiCaN3KmGcUOT+bIaz2udORD/5Galb+4X/tkP/joDqXAfmf0QxOKlRiE8IMu+ABB3Q7cMeQ+MPdzq"
    private let key: String
    
    // MARK: - Init
    init() {
        let keyData: [UInt8] = [0xBA-0x4F,0x89-0x24,0xDF-0x66,0x21+0x33,0x50+0x1F,0x30+0x15,0x1F+0x4F,0x46+0x1D,0x9A-0x28,0x87-0x0E,0xDC-0x6C,0x97-0x23,0x81-0x3D,0x3C+0x25,0x03+0x71,0x2F+0x32]
        guard let unwrappedKey = String(data: Data(keyData), encoding: .utf8) else {
            print("SSLPinning error: unable to obtain local public key")
            self.key = ""
            return
        }
        self.key = unwrappedKey
    }

    // MARK: - Methods
    
    /// Pads a given key to be used in AES encryption with 32 bytes long by default. It uses the PKCS7 standard padding.
    private func paddedKey_PKCS7(from key: String, withSize size: AESKeySize = .bits256) -> Data {
        guard let keyData = key.data(using: .utf8) else { return Data() }
        if keyData.count == size.rawValue { return keyData }
        if keyData.count > size.rawValue { return keyData.prefix(size.rawValue) }
        let paddingSize = size.rawValue - keyData.count % size.rawValue
        let paddingByte: UInt8 = UInt8(paddingSize)
        let padding = Data(repeating: paddingByte, count: paddingSize)
        return keyData + padding
    }
    
    /// Decrypts a given data input using AES algorithm.
    private func decrypt(input: Data, key: String) -> Data {
        do {
            let keyData = paddedKey_PKCS7(from: key, withSize: .bits128)
            let key = SymmetricKey(data: keyData)
            let box = try AES.GCM.SealedBox(combined: input)
            let opened = try AES.GCM.open(box, using: key)
            return opened
        } catch {
            return "Error while decryption".data(using: .utf8)!
        }
    }
    
    public func getDecryptedPublicKey() -> String? {
        guard let sealedDataBoxData = Data(base64Encoded: sealedDataBox) else {
            print("Error while decrypting the public key: sealed box is not valid")
            return nil
        }
        let data = decrypt(input: sealedDataBoxData, key: key)
        return String(data: data, encoding: .utf8)
    }
}
