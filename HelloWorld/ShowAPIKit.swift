//
//  ShowAPIKit.swift
//  HelloWorld
//
//  Created by yueshu on 2019/6/17.
//  Copyright © 2019年 yueshu. All rights reserved.
//

import UIKit

import APIKit

class ShowAPIKit {
    
    init(){
        let request = RateLimitRequest()
        
        Session.send(request) { result in
            switch result {
            case .success(let rateLimit):
                // Type of `rateLimit` is inferred as `RateLimit`,
                // which is also known as `RateLimitRequest.Response`.
                print("limit: \(rateLimit.limit)")
                print("remaining: \(rateLimit.remaining)")
                
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}

struct RateLimitRequest: Request {
    typealias Response = RateLimit
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/rate_limit"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> RateLimit {
        return try RateLimit(object: object)
    }
}

struct RateLimit {
    let limit: Int
    let remaining: Int
    
    init(object: Any) throws {
        guard let dictionary = object as? [String: Any],
            let rateDictionary = dictionary["rate"] as? [String: Any],
            let limit = rateDictionary["limit"] as? Int,
            let remaining = rateDictionary["remaining"] as? Int else {
                throw ResponseError.unexpectedObject(object)
        }
        
        self.limit = limit
        self.remaining = remaining
    }
}
