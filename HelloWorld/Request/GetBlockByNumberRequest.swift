//
//  GetBlockByNumberRequest.swift
//  HelloWorld
//
//  Created by 鲁鲁修 on 2019/6/25.
//  Copyright © 2019 yueshu. All rights reserved.
//

import Foundation
import JSONRPCKit

struct GetBlockByNumberRequest: JSONRPCKit.Request {
    typealias Response = String
    
    let data: String
    
    var method: String {
        return "eth_getBlockByNumber"
    }
    
    var parameters: Any? {
        return [data, false]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
