//
//  ShowBigInt.swift
//  HelloWorld
//
//  Created by yueshu on 2019/6/17.
//  Copyright © 2019年 yueshu. All rights reserved.
//

import UIKit
import BigInt

class ShowBigInt {
    
    init() {
        
        //初始化
        let a: BigInt = 1234567890
        let b: BigInt = "12345678901234567890123456789012345678901234567890"
        
        //基本运算
        let c: BigInt = a + b
        let c2: BigInt = b - a
        let c3: BigInt = -b
        let c4: BigInt = a * b
        let c5: BigInt = b / a
        let c6: BigInt = a % b
        let c7: BigInt = a / (b * b)
        
        //获取长度
        let d = String(c4).count
        
        print("a: \(a)")
        print("b: \(b)")
        print("c：\(c)")
        print("c2：\(c2)")
        print("c3：\(c3)")
        print("c4：\(c4)")
        print("c5：\(c5)")
        print("c6：\(c6)")
        print("c7：\(c7)")
        print("d：\(d)")

        print("factorial 100: \(factorial(100))")
        
        print("prime1 1024: \(generatePrime(1024))")
        print("prime1 1024: \(generatePrime(1024))")
    }

    func factorial(_ n: Int) -> BigInt {
        return (1 ... n).map { BigInt($0) }.reduce(BigInt(1), *)
    }

    func generatePrime(_ width: Int) -> BigUInt {
        while true {
            var random = BigUInt.randomInteger(withExactWidth: width)
            random |= BigUInt(1)
            if random.isPrime() {
                return random
            }
        }
    }
}
