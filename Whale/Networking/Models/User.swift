//
//  User.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/6/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Gloss

struct User {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let profileImageUrl: URL?
    let authenticationToken: String
    let followerCount: Int
    let followingCount: Int
}

extension User: Glossy {
    init?(json: JSON) {
        guard let id: Int = "id" <~~ json,
            let email: String = "email" <~~ json,
            let firstName: String = "first_name" <~~ json,
            let lastName: String = "last_name" <~~ json,
            let authenticationToken: String = "authentication_token" <~~ json,
            let followerCount: Int = "follower_count" <~~ json,
            let followingCount: Int = "following_count" <~~ json
            
            else {return nil}
        
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageUrl = "image_url" <~~ json
        self.authenticationToken = authenticationToken
        self.followerCount = followerCount
        self.followingCount = followingCount
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "email" ~~> email,
            "first_name" ~~> firstName,
            "last_name" ~~> lastName,
            "username" ~~> "\(firstName)_\(lastName)",
            "image_url" ~~> profileImageUrl?.absoluteString
            ])
    }
}
