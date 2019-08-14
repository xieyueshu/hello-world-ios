//
//  SymmetricCryptor.swift
//  HelloWorld
//
//  Created by yueshu on 2019/6/26.
//  Copyright © 2019 yueshu. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

/*
 * 常用枚举对象，该对象包括可以方便获得加密方法名称、及相应IV矢量数据的长度、相应密钥的长度等。
 */
enum SymmetricCryptorAlgorithm {
    case des        // DES standard, 64 bits key
    case des40      // DES, 40 bits key
    case tripledes  // 3DES, 192 bits key
    case rc2_40     // RC2, 40 bits key
    case rc2_128    // RC2, 128 bits key
    case rc4_40     // RC4, 40 bits key
    case rc4_128    // RC4, 128 bits key
    case aes_128    // AES, 128 bits key
    case aes_256    // AES, 256 bits key
    
    func ccAlgorithm() -> CCAlgorithm {
        switch (self) {
        case .des: return CCAlgorithm(kCCAlgorithmDES)
        case .des40: return CCAlgorithm(kCCAlgorithmDES)
        case .tripledes: return CCAlgorithm(kCCAlgorithm3DES)
        case .rc4_40: return CCAlgorithm(kCCAlgorithmRC4)
        case .rc4_128: return CCAlgorithm(kCCAlgorithmRC4)
        case .rc2_40: return CCAlgorithm(kCCAlgorithmRC2)
        case .rc2_128: return CCAlgorithm(kCCAlgorithmRC2)
        case .aes_128: return CCAlgorithm(kCCAlgorithmAES)
        case .aes_256: return CCAlgorithm(kCCAlgorithmAES)
        }
    }
    
    func requiredIVSize(_ options: CCOptions) -> Int {
        if options & CCOptions(kCCOptionECBMode) != 0 {
            return 0
        }
        switch self {
        case .des: return kCCBlockSizeDES
        case .des40: return kCCBlockSizeDES
        case .tripledes: return kCCBlockSizeDES
        case .rc4_40: return 0
        case .rc4_128: return 0
        case .rc2_40: return kCCBlockSizeRC2
        case .rc2_128: return kCCBlockSizeRC2
        case .aes_128: return kCCBlockSizeAES128
        case .aes_256: return kCCBlockSizeAES128 // AES256 still requires 256 bits IV
        }
    }
    
    func requiredKeySize() -> Int {
        switch (self) {
        case .des: return kCCKeySizeDES
        case .des40: return 5 // 40 bits = 5x8
        case .tripledes: return kCCKeySize3DES
        case .rc4_40: return 5
        case .rc4_128: return 16 // RC4 128 bits = 16 bytes
        case .rc2_40: return 5
        case .rc2_128: return kCCKeySizeMaxRC2 // 128 bits
        case .aes_128: return kCCKeySizeAES128
        case .aes_256: return kCCKeySizeAES256
        }
    }
    
    func requiredBlockSize() -> Int {
        switch (self) {
        case .des: return kCCBlockSizeDES
        case .des40: return kCCBlockSizeDES
        case .tripledes: return kCCBlockSize3DES
        case .rc4_40: return 0
        case .rc4_128: return 0
        case .rc2_40: return kCCBlockSizeRC2
        case .rc2_128: return kCCBlockSizeRC2
        case .aes_128: return kCCBlockSizeAES128
        case .aes_256: return kCCBlockSizeAES128 // AES256 still requires 128 bits IV
        }
    }
}

/*
 * 对称加密解密类。封装了对称加密和解密的方法，提供生成随机密钥的方法，方便调用。
 */
class SymmetricCryptor {
    
    var algorithm: SymmetricCryptorAlgorithm    // Algorithm
    var options: CCOptions                      // Options (i.e: kCCOptionECBMode + kCCOptionPKCS7Padding)
    var iv: Data?                               // Initialization Vector
    
    init(algorithm: SymmetricCryptorAlgorithm, options: Int) {
        self.algorithm = algorithm
        self.options = CCOptions(options)
    }
    
    convenience init(algorithm: SymmetricCryptorAlgorithm, options: Int, iv: String, encoding: String.Encoding = String.Encoding.utf8) {
        self.init(algorithm: algorithm, options: options)
        self.iv = iv.data(using: encoding)
    }
    
    // 加密数据
    func crypt(data: Data, key: String) throws -> Data {
        return try cryptoOperation(data, key: key, operation: CCOperation(kCCEncrypt))
    }
    
    // 解密数据
    func decrypt(_ data: Data, key: String) throws -> Data {
        return try self.cryptoOperation(data, key: key, operation: CCOperation(kCCDecrypt))
    }
    
    /*
     * 主要加密/解密的实现方法
     */
    func cryptoOperation(_ inputData: Data, key: String, operation: CCOperation) throws -> Data {
        
        if iv == nil && (self.options & CCOptions(kCCOptionECBMode)) == 0 {
            throw(SymmetricCryptorError.missingIV)
        }
        
        // 准备加密或解密的数据

        let keyData: Data = key.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyBytes = keyData.withUnsafeBytes({ (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        })
        let keyLength = size_t(algorithm.requiredKeySize())
        
        let dataLength = Int(inputData.count)
        let dataBytes = inputData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        }
        
        var bufferData = Data(count: Int(dataLength) + algorithm.requiredBlockSize())
        let bufferPointer = bufferData.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        }
        let bufferLength = size_t(bufferData.count)
        
        
        let ivBuffer: UnsafePointer<UInt8>? = (iv == nil) ? nil : iv!.withUnsafeBytes({ (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        })
        
        var bytesDecrypted = Int(0)
        
        // 执行加密或解密动作
        
        let cryptStatus = CCCrypt(
            operation,
            algorithm.ccAlgorithm(),
            options,
            keyBytes,
            keyLength,
            ivBuffer,
            dataBytes,
            dataLength,
            bufferPointer,
            bufferLength,
            &bytesDecrypted)
        
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            bufferData.count = bytesDecrypted
            return bufferData as Data
        } else {
            throw(SymmetricCryptorError.cryptOperationFailed)
        }
    }
    
    /*
     * 随机生成指定长度字符串，字符串的内容由大小写字母及数字组成；
     * 返回值类型为Data
     */
    class func randomDataOfLength(_ length: Int) -> Data? {
        var mutableData = Data(count: length)
        let bytes = mutableData.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        }
        let status = SecRandomCopyBytes(kSecRandomDefault, length, bytes)
        return status == 0 ? mutableData as Data : nil
    }
    
    /*
     * 随机生成指定长度字符串，字符串的内容由大小写字母及数字组成；可用于密钥的生成。
     * 返回值类型为String
     */
    class func randomStringOfLength(_ length:Int) -> String {
        var string = ""
        for _ in (1...length) {
            string.append(kSymmetricCryptorRandomStringGeneratorCharset[Int(arc4random_uniform(UInt32(kSymmetricCryptorRandomStringGeneratorCharset.count) - 1))])
        }
        return string
    }
    
    /*
     * 根据不同算法需要，可以设置相应的IV数据。
     */
    func setRandomIV() {
        let length = self.algorithm.requiredIVSize(self.options)
        self.iv = SymmetricCryptor.randomDataOfLength(length)
    }
}

enum SymmetricCryptorError: Error {
    case missingIV
    case cryptOperationFailed
    case wrongInputData
    case unknownError
}

private let kSymmetricCryptorRandomStringGeneratorCharset: [Character] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".map({$0})
