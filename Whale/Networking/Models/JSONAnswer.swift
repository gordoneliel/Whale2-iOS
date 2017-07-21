//
//  JSONAnswer.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/6/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Gloss

struct JSONAnswer {
    let id: Int
    let videoURL: URL
    let thumbnailURL: URL
    let question: JSONQuestion
    let likesCount: Int
    let commentsCount: Int
}

extension JSONAnswer: Gloss.Decodable {
    init?(json: JSON) {
        guard let id: Int = "id" <~~ json,
        let videoURL: URL = "video_url" <~~ json,
        let thumbnailURL: URL = "thumbnail_url" <~~ json,
        let question: JSONQuestion = "question" <~~ json
            else {return nil}
        
        self.id = id
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
        self.question = question
        self.likesCount = "likes_count" <~~ json ?? 0
        self.commentsCount = "comment_count" <~~ json ?? 0
    }
}
