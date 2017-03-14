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

extension JSONComment: Decodable {
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
