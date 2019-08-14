//
//  GetBalanceRequest.swift
//  HelloWorld
//
//  Created by 鲁鲁修 on 2019/6/24.
//  Copyright © 2019 yueshu. All rights reserved.
//

import Foundation
import JSONRPCKit

struct BalanceRequest: JSONRPCKit.Request {
    typealias Response = String
    
    let address: String
    
    var method: String {
        return "eth_getBalance"
    }
    
    var parameters: Any? {
        return [address, "latest"]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
