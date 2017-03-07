//
//  CoreApiClient.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/7/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Moya

enum CoreApiClient {
    case me
    case authenticateUser(email: String, password: String)
    case createUser(
        firstName: String,
        lastName: String,
        email: String,
        phoneNumber: String,
        password: String
    )
    case updateUser(firstName: String, lastName: String, phone: String, data: Data?)
//    case followUser(userId: Int)
//    case unfollowUser(userId: Int)
    
//    case answers(page: Int, pageSize: Int)
//    case comments(answerId: Int, page: Int, pageSize: Int)
    
}

extension CoreApiClient: TargetType {
    var base: String { return "https://someapp.herokuapp.com/api/" }
    var baseURL: URL { return URL(string: base)! }
    
    var path: String {
        switch self {
        case .me:
            return "v1/users"
        case .authenticateUser:
            return "v1/sessions"
        case .createUser:
            return "v1/users"
        case .updateUser:
            return "v1/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .me:
            return .get
        case .authenticateUser:
            return .get
        case .createUser:
            return .post
        case .updateUser:
            return .patch
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .me:
            return [:]
        case .authenticateUser:
            return [:]
        case .createUser:
            return [:]
        case .updateUser:
            return [:]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        return .request
    }
    
    var sampleData: Data {
        switch self {
        case .me:
            return stubbedResponse("user")
        case .authenticateUser:
            return stubbedResponse("user")
        case .createUser:
            return stubbedResponse("user")
        case .updateUser:
            return stubbedResponse("user")
        }
    }
}

func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject {}
    
    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}
