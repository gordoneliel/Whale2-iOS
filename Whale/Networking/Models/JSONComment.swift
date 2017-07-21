//
//  Comment.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/6/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Gloss

struct JSONComment {
    let id: Int
    let content: String
    let commenter: JSONUser
}

extension JSONComment: Gloss.Decodable {
    
    // Used for posting a comment, we don't need commenter or id
    init(content: String) {
        self.content = content
        self.id = -1
        self.commenter = JSONUser(id: -1, email: "'", firstName: "", lastName: "", profileImageUrl: nil, followerCount: nil, followingCount: nil)
    }
    
    init?(json: JSON) {
        guard let id: Int = "id" <~~ json,
            let content: String = "content" <~~ json,
            let commenter: JSONUser = "commenter" <~~ json
            else {return nil}
        
        self.id = id
        self.content = content
        self.commenter = commenter
    }
}

extension JSONComment: Gloss.Encodable {
    func toJSON() -> JSON? {
        return [
            "content": self.content
        ]
    }
}
