//
//  Moya+Extensions.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/8/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Moya
import Gloss

enum WhaleError: Swift.Error {
    case couldNotParseJSON
    case notLoggedIn
    case missingData
    case couldNotParseHeader
}

extension Moya.Response {
    
    func mapAuthHeader() throws -> String {
        let authResponse = response as? HTTPURLResponse
        
        guard let authHeader = authResponse?.allHeaderFields["Authorization"] as? String else {throw WhaleError.couldNotParseHeader}
        
        return authHeader
    }
    /**
     Get given JSONified data, pass back an object
     
     - parameter classType: The model<T> call to decode to
     
     - returns: The model<T>
     */
    func mapTo<T: Gloss.Decodable>(_ classType: T.Type) throws -> T {
        guard
            let json = try mapJSON() as? JSON,
            let result = T(json: json)
            
            else {throw WhaleError.couldNotParseJSON}
        
        return result
        
    }
    
    /**
     Get given JSONified data, pass back objects as an array
     
     - parameter classType: The models<[T]> call to decode to
     - parameter nestedKey: A nested key value in the json to unwrap
     
     - returns: An array of models<[T]>
     */
    func mapToArray<T: Gloss.Decodable>(_ classType: T.Type) throws -> [T] {
        guard let json = try mapJSON() as? [JSON] else {
            throw WhaleError.couldNotParseJSON
        }
        
        let value = [T].from(jsonArray: json) ?? []
        return value
        
    }
}
