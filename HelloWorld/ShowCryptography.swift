//
//  ShowCryptography.swift
//  HelloWorld
//
//  Created by yueshu on 2019/6/26.
//  Copyright © 2019 yueshu. All rights reserved.
//

import Foundation
import CommonCrypto

class ShowCryptography {
    init() {
//        symmetricCrypto()
//        MD5Demo()
//        macDemo()
//        asymmetricCrypto()
        digitalSignatureAlgorithm()
//        pbkdf2Demo()
    }
    
    /*
     * 对称加密解密演示  --- AES256算法
     */
    func symmetricCrypto() {
        
        /// AES 256
        let algorithm = SymmetricCryptorAlgorithm.aes_256
        /// 生成随机密钥
        let key = SymmetricCryptor.randomStringOfLength(algorithm.requiredKeySize())
        print("AES256随机密钥：\(key)")
        
        /// 设置PKCS7模式
        let option = kCCOptionPKCS7Padding
        /// 生成对称加密对象
        let cypher = SymmetricCryptor(algorithm: algorithm, options: option)
        /// 设置iv
        cypher.setRandomIV()
        
        /// 明文
        let clearText = "Hello world! Hello iOS!"
         let data = clearText.data(using: String.Encoding.utf8)!
        var cypherData = Data()
        
        print("明文：\(clearText)")
        
        /// 加密
        do {
            cypherData = try cypher.crypt(data: data, key: key)
            print("密文：\(cypherData.toHexString())")
        } catch {
            print(error)
        }
        
        /// 解密
        do {
            let clearData = try cypher.decrypt(cypherData, key: key)
            let text = String(data: clearData, encoding: .utf8) ?? ""
            print("解密：\(text)")
        } catch {
            print(error)
        }
    }
    
    /*
     * MD消息摘要 --- MD5
     */
    func MD5Demo() {
        let text1 = "Hello world"
        let text2 = "Hello world!"
        let text3 = "Hello world! Hello world! fdsafsa 123y8291343712899431 hfdsafds Hello world!"
        
        print("text1: "+text1)
        print("text2: "+text2)
        print("text3: "+text3)
        
        let text1_md5 = md5(text1)
        let text2_md5 = md5(text2)
        let text3_md5 = md5(text3)
        
        print("MD5_1: "+text1_md5)
        print("MD5_2: "+text2_md5)
        print("MD5_3: "+text3_md5)
    }
    
    func md5(_ text: String) -> String {
        let str = text.cString(using: String.Encoding.utf8)!
        let strLength = CUnsignedInt(text.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str, strLength, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return hash as String
    }
    
    func macDemo() {
        let str = "This is our string."
        let key = "TheKeyForEncryption."
        
        print("文字：\(str)")
        print("密钥：\(key)")
        
        let hmac_sha1 = str.hmac(algorithm: .sha1, key: key)
        print("HMAC_SHA1：\(hmac_sha1)")
        let hmac_md5 = str.hmac(algorithm: .sha512, key: key)
        print("HMAC_MD5：\(hmac_md5)")
    }
    
    /*
     * 非对称加密  --- RSA
     */
    func asymmetricCrypto() {
        
        // 生成密钥对
        guard let keyPairs = try? RSA.generateAsymmetricKeyPair("com.example.keys.mykey") else {
            print("生成密钥对失败")
            return
        }
        let publicKey = keyPairs.publicKey
        let privateKey = keyPairs.privateKey
        
        // 明文
        let originalText = "This is our original string."
        let originalData = originalText.data(using: String.Encoding.utf8)!
        print("明文：\(originalText)")
        
        guard let encryData = try? RSA.encrypt(publicKey: publicKey, data: originalData) else {
            print("RSA加密失败")
            return
        }
        print("RSA加密：\(encryData.toHexString())")
        
        guard let decryptData = try? RSA.decrypt(privateKey: privateKey, data: encryData)  else {
            print("RSA解密密失败")
            return
        }
        
        let text = String(data: decryptData, encoding: .utf8) ?? ""
        print("RSA解密：\(text)")
    }
    
    /// 数字签名
    func digitalSignatureAlgorithm() {
        // 密钥对
        guard let keyPairs = try? RSA.generateAsymmetricKeyPair("com.example.keys.mykey") else {
            print("生成密钥对失败")
            return
        }
        
        let publicKey = keyPairs.publicKey
        let privateKey = keyPairs.privateKey
        
        // 明文
        let originalText = "Stay hungry, Stay foolish"
        let originalData = originalText.data(using: String.Encoding.utf8)!
        
        print("明文：\(originalText)")
        
        guard let signedData = try? RSA.sign(privateKey: privateKey, data: originalData) else {
            print("签名过程中失败")
            return
        }
        print("RSA签名：\(signedData.toHexString())")
        
        guard let result = try? RSA.verifySignature(publicKey: publicKey, data: originalData, signedData: signedData) else {
            print("验证过程中失败")
            return
        }
        
        if result {
            print("签名验证成功")
        } else {
            print("签名验证失败")
        }
    }
    
    func pbkdf2Demo() {
        let password     = "password"
        let salt         = "fdsjalfdjsakl"
        let keyByteCount = 16
        let rounds       = 100000
        
        guard let derivedKey = pbkdf2(hash: CCPBKDFAlgorithm(kCCPRFHmacAlgSHA1), password: password, salt: salt, keyByteCount: keyByteCount, rounds: rounds) else {
            print("生成失败")
            return
        }
        
        print("derivedKey (SHA1): \(derivedKey.map { String(format: "%02x", $0) }.joined())")
        
        guard let derivedKey2 = pbkdf2(hash: CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256), password: password, salt: salt, keyByteCount: keyByteCount, rounds: rounds) else {
            print("生成失败")
            return
        }
        
        print("derivedKey (SHA256): \(derivedKey2.map { String(format: "%02x", $0) }.joined())")
        
        guard let derivedKey3 = pbkdf2(hash: CCPBKDFAlgorithm(kCCPRFHmacAlgSHA512), password: password, salt: salt, keyByteCount: keyByteCount, rounds: rounds) else {
            print("生成失败")
            return
        }
        
        print("derivedKey (SHA512): \(derivedKey3.map { String(format: "%02x", $0) }.joined())")

    }
    
    func pbkdf2(hash: CCPBKDFAlgorithm, password: String, salt: String, keyByteCount: Int, rounds: Int) -> Data? {
        guard let passwordData = password.data(using: .utf8), let saltData = salt.data(using: .utf8) else { return nil }
        
        var derivedKeyData = Data(repeating: 0, count: keyByteCount)
        let derivedCount = derivedKeyData.count
        
        let derivationStatus = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
            saltData.withUnsafeBytes { saltBytes in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password,
                    passwordData.count,
                    saltBytes,
                    saltData.count,
                    hash,
                    UInt32(rounds),
                    derivedKeyBytes,
                    derivedCount)
            }
        }
        
        return derivationStatus == kCCSuccess ? derivedKeyData : nil
    }

}
