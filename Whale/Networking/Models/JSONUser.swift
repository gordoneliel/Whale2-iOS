//
//  User.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/6/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Gloss

struct JSONUser {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let profileImageUrl: URL?
    let followerCount: Int?
    let followingCount: Int?
    let updatedAt = Date()
}

extension JSONUser: Glossy {
    init?(json: JSON) {
        guard let id: Int = "id" <~~ json,
            let email: String = "email" <~~ json,
            let firstName: String = "first_name" <~~ json,
            let lastName: String = "last_name" <~~ json
            else {return nil}
        
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageUrl = "image_url" <~~ json
        self.followerCount = "follower_count" <~~ json
        self.followingCount = "following_count" <~~ json
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
