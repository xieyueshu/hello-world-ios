//
//  GetTransactionRequest.swift
//  HelloWorld
//
//  Created by 鲁鲁修 on 2019/6/24.
//  Copyright © 2019 yueshu. All rights reserved.
//

import Foundation
import JSONRPCKit

struct GetTransactionRequest: JSONRPCKit.Request {
    typealias Response = [String: AnyObject]
    
    let hash: String
    
    var method: String {
        return "eth_getTransactionByHash"
    }
    
    var parameters: Any? {
        return [hash]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
