//
//  SendTransactionRequest.swift
//  HelloWorld
//
//  Created by 鲁鲁修 on 2019/6/24.
//  Copyright © 2019 yueshu. All rights reserved.
//

import Foundation
import JSONRPCKit
import BigInt

struct SendTransactionRequest: JSONRPCKit.Request {
    typealias Response = String
    
    let transaction: SignTransaction
    
    var method: String {
        return "eth_sendTransaction"
    }
    
    var parameters: Any? {
        return [
            [
                "from": transaction.from,
                "to": transaction.to ?? "",
                "gas": transaction.gas.hexEncoded,
                "gasPrice": transaction.gasPrice.hexEncoded,
                "value": transaction.value.hexEncoded,
                "data": transaction.data.hexEncoded,
                "nonce": transaction.nonce.hexEncoded
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

public struct SignTransaction {
    let from: String
    let to: String?
    let gas: BigInt
    let value: BigInt
    let nonce: BigInt
    let data: Data
    let gasPrice: BigInt
    let gasLimit: BigInt
}

extension Data {
    var hex: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    var hexEncoded: String {
        return "0x" + self.hex
    }
}
