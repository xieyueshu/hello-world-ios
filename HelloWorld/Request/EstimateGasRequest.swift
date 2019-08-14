//
//  EstimateGasRequest.swift
//  HelloWorld
//
//  Created by 鲁鲁修 on 2019/6/24.
//  Copyright © 2019 yueshu. All rights reserved.
//

import Foundation
import JSONRPCKit
import BigInt

struct EstimateGasRequest: JSONRPCKit.Request {
    typealias Response = String
    
    let transaction: SignTransaction
    
    var method: String {
        return "eth_estimateGas"
    }
    
    var parameters: Any? {
        return [
            [
                "from": transaction.from,
                "to": transaction.to ?? "",
                "gasPrice": transaction.gasPrice.hexEncoded,
                "value": transaction.value.hexEncoded,
                "data": transaction.data.hexEncoded,
                ]
        ]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
