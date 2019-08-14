//
//  RSA2.swift
//  HelloWorld
//
//  Created by yueshu on 2019/6/26.
//  Copyright © 2019 yueshu. All rights reserved.
//

import Foundation
import CommonCrypto

class RSA {
    
    /// 生成随机的密钥
    static func generateAsymmetricKeyPair(_ tagString: String) throws -> (publicKey: SecKey, privateKey: SecKey) {
        let tag = tagString.data(using: .utf8)!
        let attributes: [String: Any] =
            [kSecAttrKeyType as String:            kSecAttrKeyTypeRSA,
             kSecAttrKeySizeInBits as String:      2048,
             kSecPrivateKeyAttrs as String:
                [kSecAttrIsPermanent as String:    true,
                 kSecAttrApplicationTag as String: tag]
        ]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            throw RSACryptorError.generateKeyPairFail
        }
        
        return (publicKey, privateKey)
    }

    /// 加密
    static func encrypt(publicKey: SecKey, data: Data) throws -> Data {
        let cipherBufferSize = SecKeyGetBlockSize(publicKey)
        var encryptBytes = [UInt8](repeating: 0, count: cipherBufferSize)
        var outputSize: Int = cipherBufferSize
        let status = SecKeyEncrypt(publicKey, SecPadding.PKCS1, data.arrayOfBytes(), data.count, &encryptBytes, &outputSize)
        if errSecSuccess != status {
            throw(RSACryptorError.encryptFail)
        }
        
        return Data(bytes: UnsafePointer<UInt8>(encryptBytes), count: outputSize)
    }
    
    /// 解密
    static func decrypt(privateKey: SecKey, data: Data) throws -> Data {
        
        let cipherBufferSize = SecKeyGetBlockSize(privateKey)
        var decryptBytes = [UInt8](repeating: 0, count: cipherBufferSize)
        var outputSize = cipherBufferSize
        let status = SecKeyDecrypt(privateKey, SecPadding.PKCS1, data.arrayOfBytes(), data.count, &decryptBytes, &outputSize)
        
        if errSecSuccess != status {
            throw(RSACryptorError.decryptFail)
        }
        
        return Data(bytes: UnsafePointer<UInt8>(decryptBytes), count: outputSize)
    }
    
    /// 签名
    static func sign(privateKey: SecKey, data: Data) throws -> Data {
        
        var resultData = Data(count: SecKeyGetBlockSize(privateKey))
        let resultPointer = resultData.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        })
        var resultLength = resultData.count
        
        var hashData = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
        let hash = hashData.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        })
        CC_SHA1((data as NSData).bytes.bindMemory(to: Void.self, capacity: data.count), CC_LONG(data.count), hash)
        
        // 签名
        let status = SecKeyRawSign(privateKey, SecPadding.PKCS1SHA1, hash, hashData.count, resultPointer, &resultLength)
        if status != errSecSuccess {
            throw(RSACryptorError.signFail)
        } else {
            resultData.count = resultLength
        }
        
        return resultData
    }
    
    /// 验证
    static func verifySignature(publicKey: SecKey, data: Data, signedData: Data) throws -> Bool {
        // hash data
        var hashData = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
        let hash = hashData.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        })
        CC_SHA1((data as NSData).bytes.bindMemory(to: Void.self, capacity: data.count), CC_LONG(data.count), hash)
        
        // input and output data
        let signaturePointer = (signedData as NSData).bytes.bindMemory(to: UInt8.self, capacity: signedData.count)
        let signatureLength = signedData.count
        
        let status = SecKeyRawVerify(publicKey, SecPadding.PKCS1SHA1, hash, Int(CC_SHA1_DIGEST_LENGTH), signaturePointer, signatureLength)
        
        if status != errSecSuccess {
            throw(RSACryptorError.signVerifyFail)
        }
        
        return true
    }
    
}

extension Data {
    /// Array of UInt8
    public func arrayOfBytes() -> [UInt8] {
        let count = self.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        (self as NSData).getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
        return bytesArray
    }
}

enum RSACryptorError: Error {
    case generateKeyPairFail
    case encryptFail
    case decryptFail
    case signFail
    case signVerifyFail
    case contentDecryptedTooLarge
}
