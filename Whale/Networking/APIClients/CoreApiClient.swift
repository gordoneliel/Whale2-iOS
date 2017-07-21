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
    case users(page: Int, pageSize: Int)
    
    case questions
//    case followUser(userId: Int)
//    case unfollowUser(userId: Int)
    
    case answers(page: Int, pageSize: Int)
    case createAnswer(questionId: Int, video: URL, thumbnail: URL)
    case comments(answerId: Int, page: Int, pageSize: Int)
    case createComment(answerId: Int, content: String)
    
}

extension CoreApiClient: TargetType {
    var base: String { return "https://whale2-elixir.herokuapp.com/api/" }
    var baseURL: URL { return URL(string: base)! }
    
    var path: String {
        switch self {
        case .me:
            return "v1/sessions"
        case .authenticateUser:
            return "v1/sessions"
        case .createUser:
            return "v1/users"
        case .updateUser:
            return "v1/users"
        case .users:
            return "v1/users"
        case .answers:
            return "v1/answers"
        case let .createAnswer(questionId,  _, _):
            return "v1/questions/\(questionId)/answers"
        case let .comments(answerId, _, _):
            return "v1/answers/\(answerId)/comments"
        case let .createComment(answerId, _):
            return "v1/answers/\(answerId)/comments"
        case .questions:
            return "v1/questions"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .me,
             .users,
             .answers,
             .comments,
             .questions:
            return .get
        case .createUser,
             .createComment,
             .authenticateUser,
             .createAnswer:
            return .post
        case .updateUser:
            return .patch
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .me,
             .questions,
             .createAnswer:
            return [:]
        case let .authenticateUser(email, password):
            return [
                "email": email,
                "password": password
            ]
        case .createUser:
            return [:]
        case .updateUser:
            return [:]
        case let .users(page, perPage),
             let .answers(page, perPage),
             let .comments(_, page, perPage):
            return [
                "per_page": perPage,
                "page": page
            ]
        case let .createComment(_, content):
            return [
                "comment": content
            ]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        switch self {
        case let .createAnswer(_, video, thumbnail):
            return .upload(.multipart([
                MultipartFormData(provider: .file(video), name: video.description),
                MultipartFormData(provider: .file(thumbnail), name: thumbnail.description)
                ]))
        default:
            return .request
        }
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
        case .users:
            return stubbedResponse("all_users")
        case .answers:
            return stubbedResponse("answers")
        case .createAnswer:
            return stubbedResponse("createAnswer")
        case .comments, .createComment:
            return stubbedResponse("comments")
        case .questions:
            return stubbedResponse("questions")
        }
    }
}

func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject {}
    
    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}
