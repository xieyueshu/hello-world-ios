//
//  ShowJSONRPCKit.swift
//  HelloWorld
//
//  Created by yueshu on 2019/6/22.
//  Copyright © 2019年 yueshu. All rights reserved.
//

import Foundation

import JSONRPCKit

import APIKit


class ShowJSONRPCKit {
    
    init(){
        //showBasic()
        showBaseAPIKit()
    }
    
    func showBasic(){
        
        //创建请求JSON对象
        let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
        let request1 = Subtract(minuend: 42, subtrahend: 23)
        let request2 = Subtract(minuend: 23, subtrahend: 42)
        let batch = batchFactory.create(request1, request2)
        print(batch.requestObject)
        
        //处理响应JSON对象并提取result对象
        //假设服务器处理后返回的JSON结果如下
        let responseObject =
        [
            [
                "result" : 19,
                "jsonrpc" : "2.0",
                "id" : 1,
                "status" : 0
            ],
            [
                "result" : -19,
                "jsonrpc" : "2.0",
                "id" : 2,
                "status" : 0
            ]
        ]
        
        let (response1, response2) = try! batch.responses(from: responseObject)
        print(response1) // 19
        print(response2) // -19
    }
    
    func showBaseAPIKit(){
        let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
        let request1 = Subtract(minuend: 42, subtrahend: 23)
        let request2 = Subtract(minuend: 23, subtrahend: 42)
        let batch = batchFactory.create(request1, request2)
        let httpRequest = MyServiceRequest(batch: batch)

        Session.send(httpRequest) { (result) in
            switch result {
            case .success(let response1, let response2):
                print(response1) // CountCharactersResponse
                print(response2) // CountCharactersResponse
            case .failure(let error):
                print(error)
            }
        }
    }
}

/**
 * 定义请求参数及返回result对象类型
 */
struct Subtract: JSONRPCKit.Request {
    typealias Response = Int
    
    let minuend: Int
    let subtrahend: Int
    
    var method: String {
        return "subtract"
    }
    
    var parameters: Any? {
        return [minuend, subtrahend]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}

struct MyServiceRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    let batch: Batch
    
    typealias Response = Batch.Responses
    
    var baseURL: URL {
        return URL(string: "https://jsonrpckit-demo.appspot.com")!
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/"
    }
    
    var parameters: Any? {
        return batch.requestObject
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        print(object)
        return try batch.responses(from: object)
    }
}

struct CastError<ExpectedType>: Error {
    let actualValue: Any
    let expectedType: ExpectedType.Type
}
