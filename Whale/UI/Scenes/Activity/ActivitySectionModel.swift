//
//  ActivitySectionModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/15/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation

enum ActivitySectionModel {
    case follow(title: String, items: [SectionItem])
    case question(title: String, items: [SectionItem])
}

extension ActivitySectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var header: String {
        switch self {
        case let .follow(title, _):
            return title
        case let .question(title, _):
            return title
        }
    }
    
    var items: [Item] {
        switch self {
        case let .follow(_, items):
            return items.map{ $0 }
        case let .question(_, items):
            return items.map { $0 }
        }
    }
    
    init(original: ActivitySectionModel, items: [Item]) {
        switch original {
        case let .follow(header, _):
            self = .follow(title: header, items: items)
        case let .question(header, _):
            self = .question(title: header, items: items)
        }
    }
}

struct FollowCellViewModel {
    let userName: String
}

struct MyQuestionCellViewModel {
    let question: String
}

enum SectionItem {
    case FollowCellItem(userName: String)
    case MyQuestionItem(question: String, user: String, image: URL?)
}
