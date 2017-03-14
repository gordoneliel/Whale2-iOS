//
//  CommentSectionModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/13/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation

struct CommentSectionModel {
    var header: String
    var items: [Item]
}

extension CommentSectionModel: SectionModelType {
    typealias Item = CommentCellViewModel
    
    init(original: CommentSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

struct CommentCellViewModel {
    let user: String
    let userImage: URL?
    let comment: String
}
