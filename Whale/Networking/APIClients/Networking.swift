//
//  Networking.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/7/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Moya

protocol NetworkingType {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> {get}
}

struct BaseNetworking: NetworkingType {
    typealias T = CoreApiClient
    let provider: MoyaProvider<T>
}

extension BaseNetworking {
    func request(_ token: T, completion: @escaping Completion) {
        self.provider.request(token, completion: completion)
    }
}

extension NetworkingType {
    static func endpointsClosure<T>(_ target: T) -> Endpoint<T> where T: TargetType {
        let endpoint: Endpoint<T> = Endpoint<T>(
            url: url(target),
            sampleResponseClosure: {.networkResponse(200, target.sampleData)},
            method: target.method,
            parameters: target.parameters,
            parameterEncoding: URLEncoding.default,
            httpHeaderFields: ["Authorization": "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjEiLCJleHAiOjE0OTE1NTU2OTQsImlhdCI6MTQ4ODk2MzY5NCwiaXNzIjoiV2hhbGUyIiwianRpIjoiYWQ5MDFlMjEtZWJhNC00YzdkLWJiYWUtMWVmMTEyOWExNzNhIiwicGVtIjp7fSwic3ViIjoiVXNlcjoxIiwidHlwIjoiYWNjZXNzIn0._3YO2mx0O-EqiRvkl7-OlB3oU5aXqwL4CQD5DZMKyva9gYFQ_6_a2xP9uonw25mcAQCDAid8_zOSfzW5EaoZ2A"]
        )
        
        return endpoint
    }
    
    static func newStubedNetworking() -> BaseNetworking {
        return BaseNetworking(provider: MoyaProvider(endpointClosure: endpointsClosure, stubClosure: MoyaProvider.immediatelyStub))
    }
    
    static func newNetworking() -> BaseNetworking {
        return BaseNetworking(provider: MoyaProvider(endpointClosure: endpointsClosure))
    }
    
    static func url(_ route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
}
