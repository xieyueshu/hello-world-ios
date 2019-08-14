//
//  CallRequest.swift
//  HelloWorld
//
//  Created by 鲁鲁修 on 2019/6/24.
//  Copyright © 2019 yueshu. All rights reserved.
//

import Foundation
import JSONRPCKit

struct CallRequest: JSONRPCKit.Request {
    typealias Response = String
    
    let to: String
    let data: String
    
    var method: String {
        return "eth_call"
    }
    
    var parameters: Any? {
        return [["to": to, "data": data], "latest"]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
