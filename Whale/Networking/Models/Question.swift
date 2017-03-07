//
//  Question.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/6/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Gloss

struct Question {
    let id: Int
    let content: String
}

extension Question: Decodable {
    init?(json: JSON) {
        guard let id: Int = "id" <~~ json,
            let content: String = "content" <~~ json
            else {return nil}
        
        self.id = id
        self.content = content
    }
}
