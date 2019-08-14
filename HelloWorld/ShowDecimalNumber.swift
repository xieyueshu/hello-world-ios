//
//  ShowDecimalNumber.swift
//  HelloWorld
//
//  Created by yueshu on 2019/6/15.
//  Copyright © 2019年 yueshu. All rights reserved.
//

import UIKit

class ShowDecimalNumber {
    
    init() {

        let numStr1 = "233.3435445"
        let numStr2 = "2003.12389047"
        
        let num1Decimal = Decimal(string: numStr1)!
        let num2Decimal = Decimal(string: numStr2)!
        
        // 加法
        let addDecimal = num1Decimal + num2Decimal
        print(addDecimal)
        
        // 减法
        let subDecimal = num1Decimal - num2Decimal
        print(subDecimal)
        
        // 乘法
        let multiplyDecimal = num1Decimal * num2Decimal
        print(multiplyDecimal)
        
        // 除法
        let divideDecimal = num1Decimal / num2Decimal
        print(divideDecimal)
        
        // 比较
        let isEqual = num1Decimal == num2Decimal
        print(isEqual)
        
        // 求幂
        let result = pow(num1Decimal, 3)
        print(result)

    }
}
