//
//  Question.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/6/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Gloss

struct JSONQuestion {
    let id: Int
    let content: String
    let sender: JSONUser
    let receiver: JSONUser
}

extension JSONQuestion: Decodable {
    init?(json: JSON) {
        guard let id: Int = "id" <~~ json,
            let content: String = "content" <~~ json,
            let sender: JSONUser = "sender" <~~ json,
            let receiver: JSONUser = "receiver" <~~ json
            else {return nil}
        
        self.id = id
        self.content = content
        self.sender = sender
        self.receiver = receiver
    }
}
