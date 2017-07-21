//
//  JSONPageMeta.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/8/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Gloss

struct PageData<T: Gloss.Decodable> {
    let page: Int
    let perPage: Int
    let totalPages: Int
    let data: [T]
}

extension PageData: Gloss.Decodable {
    init?(json: JSON) {
        guard let page: Int = "page" <~~ json,
            let perPage: Int = "per_page" <~~ json,
            let data: [T] = "data" <~~ json,
            let totalPages: Int = "total_pages" <~~ json
            
            else {return nil}
        
        self.page = page
        self.perPage = perPage
        self.data = data
        self.totalPages = totalPages
    }
}
