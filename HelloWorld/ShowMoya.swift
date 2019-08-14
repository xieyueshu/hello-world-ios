//
//  ShowMoya.swift
//  HelloWorld
//
//  Created by yueshu on 2019/6/17.
//  Copyright © 2019年 yueshu. All rights reserved.
//

import UIKit
import Moya


class ShowMoya {
    
    init() {
        let provider = MoyaProvider<GithubService>()
        provider.request(.rateLimit) {
            result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                // do something with the response data or statusCode
                print("data: \(data)")
                print("statusCode: \(statusCode)")
            case let .failure(error):
                print(error)
                break
            }
        }
        
    }
}

enum GithubService {
    case rateLimit
}

//MARK: - TargetType Protocol Implementation
extension GithubService: TargetType {
    var baseURL: URL {return URL(string:"https://api.github.com")!}
    var path: String {
        switch self {
        case .rateLimit:
            return "/rate_limit"
        }
    }
    var method: Moya.Method{
        switch self{
        case .rateLimit:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .rateLimit:
            // Send no parameters
            return .requestPlain
        }
    }
    var sampleData: Data {
        return Data()
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
