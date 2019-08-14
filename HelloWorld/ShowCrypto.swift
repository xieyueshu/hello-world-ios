//
//  ShowCrypto.swift
//  HelloWorld
//
//  Created by yueshu on 2019/6/21.
//  Copyright © 2019年 yueshu. All rights reserved.
//

import Foundation

import CryptoSwift

class ShowCrypto {
    
    init() {
        showBasic()
        showDigest()
        showPBKD()
        showAES()
    }
    
    /**
     * 演示基本数据类型转换
     */
    func showBasic(){
        
        let data = Data( [0x01, 0x02, 0x03])
        
        let bytes1 = data.bytes                     // [1,2,3]
        let bytes2 = Array<UInt8>(hex: "0x010203")  // [1,2,3]
        let bytes3: Array<UInt8> = "cipherkey".bytes  // Array("cipherkey".utf8)
        
        let hex   = bytes2.toHexString()            // "010203"

        print("data: \(data)")
        print("bytes1: \(bytes1)")
        print("bytes2: \(bytes2)")
        print("bytes3: \(bytes3)")
        print("hex: \(hex)")
    }
    
    /**
     * 演示数字摘要方法的使用
     */
    func showDigest(){
        
        let bytes:Array<UInt8> = [0x01, 0x02, 0x03]
        
        //通过Digest对象调用方法获得摘要
        let result = Digest.md5(bytes)
        
        //通过bytes扩展的方法获得摘要
        let result1 = bytes.md5()

        print("result: \(result)")
        print("result1: \(result1)")

        //通过多个步骤多次输入内容来获得摘要
        do {
            var digest = MD5()
            let partial1 = try digest.update(withBytes: [0x01, 0x02])
            let partial2 = try digest.update(withBytes: [0x03])
            let result2 = try digest.finish()
            print("result2: \(result2)")
        } catch { }

        let hash1 = bytes.sha1()
        let hash2 = bytes.sha224()
        let hash3 = bytes.sha256()
        let hash4 = bytes.sha384()
        let hash5 = bytes.sha512()
        
        //通过string扩展方法获得摘要
        let hash = "123".md5() // "123".bytes.md5()
        
        print("sha1: \(hash1)")
        print("sha224: \(hash2)")
        print("sha256: \(hash3)")
        print("sha384: \(hash4)")
        print("sha512: \(hash5)")
        print("hash: \(hash)")
}
    
    func showCRC(){
        
        let bytes:Array<UInt8> = [0x01, 0x02, 0x03]
        let data = Data( [0x01, 0x02, 0x03])

        bytes.crc16()
        data.crc16()
        
        bytes.crc32()
        data.crc32()
    }
    
    func showMAC() throws {
        
        let bytes:Array<UInt8> = [0x01, 0x02, 0x03]

        // Calculate Message Authentication Code (MAC) for message
        let key:Array<UInt8> = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        
        try Poly1305(key: key).authenticate(bytes)
        try HMAC(key: key, variant: .sha256).authenticate(bytes)
        try CMAC(key: key).authenticate(bytes)
    }
    
    /**
     * 演示密码输出方法的使用
     */
    func showPBKD() {
        
        //使用PBKDF2输出密钥
        let password: Array<UInt8> = Array("s33krit".utf8)
        let salt: Array<UInt8> = Array("nacllcan".utf8)
        let key = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, keyLength: 32, variant: .sha256).calculate()
        
        //使用Scrypt输出密钥
        let password2: Array<UInt8> = Array("s33krit".utf8)
        let salt2: Array<UInt8> = Array("nacllcan".utf8)
        let key2 = try! Scrypt(password: password2, salt: salt2, dkLen: 64, N: 16384, r: 8, p: 1).calculate()

        print("key: \(key)")
        print("key2: \(key2)")

    }
    
    func showHMACBKD() throws {
        
        let password: Array<UInt8> = Array("s33krit".utf8)
        let salt: Array<UInt8> = Array("nacllcan".utf8)
        
        let key = try HKDF(password: password, salt: salt, variant: .sha256).calculate()
    }
    
    func showDataPadding(){
        
        let bytes:Array<UInt8> = [0x01, 0x02, 0x03]

        Padding.pkcs7.add(to: bytes, blockSize: AES.blockSize)
    }
    
    /**
     * 演示AES加密解密方法的使用
     */
    func showAES() {
        
        //try AES(key: [1,2,3,...,32], blockMode: CBC(iv: [1,2,3,...,16]), padding: .pkcs7)
        
        //一次性加密使用方式
        do {
            let aes = try AES(key: "keykeykeykeykeyk", iv: "drowssapdrowssap") // aes128
            let ciphertext = try aes.encrypt(Array("My Hello Text.".utf8))
            
            print("ciphertext: \(ciphertext)")
        } catch {
            print(error)
         }
        
        //多次输入内容的z加密s方式
        do {
            var encryptor = try AES(key: "keykeykeykeykeyk", iv: "drowssapdrowssap").makeEncryptor()
            
            var ciphertext = Array<UInt8>()
            // aggregate partial results
            ciphertext += try encryptor.update(withBytes: Array("My ".utf8))
            ciphertext += try encryptor.update(withBytes: Array("My  ".utf8))
            ciphertext += try encryptor.update(withBytes: Array("Text.".utf8))
            // finish at the end
            ciphertext += try encryptor.finish()
            
            print("ciphertext2: \(ciphertext.toHexString())")
            
        } catch {
            print(error)
        }
        
        //加密解密全过程演示
        let input: Array<UInt8> = [0,1,2,3,4,5,6,7,8,9]
        let key: Array<UInt8> = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
        let iv: Array<UInt8> = AES.randomIV(AES.blockSize)
        do {
            let encrypted = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(input)
            let decrypted = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(encrypted)
        
            print("input: \(input)")
            print("encrypted: \(encrypted)")
            print("decrypted: \(decrypted)")
        } catch {
            print(error)
        }
        
    }
}
