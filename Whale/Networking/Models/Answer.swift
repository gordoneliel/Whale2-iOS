//
//  Answer.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/6/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Gloss

struct Answer {
    let id: Int
    let videoURL: URL
    let thumbnailURL: URL
}

extension Answer: Decodable {
    init?(json: JSON) {
        guard let id: Int = "id" <~~ json,
        let videoURL: URL = "video_url" <~~ json,
        let thumbnailURL: URL = "thumbnail_url" <~~ json
            else {return nil}
        
        self.id = id
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
    }
}
