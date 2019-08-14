//
//  ShowOC.swift
//  HelloWorld
//
//  Created by yueshu on 2019/6/18.
//  Copyright © 2019年 yueshu. All rights reserved.
//

import Foundation

class ShowOC {
    
    var sayHi: FKSayHi!
    
    init() {
        //创建Objective-C类：FKSayHi的对象
        sayHi = FKSayHi(date: Date())
        let rs = sayHi.sayHi("谢跃书")
        print(rs)
    }
}
