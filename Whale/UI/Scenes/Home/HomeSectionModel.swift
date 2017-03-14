//
//  HomeSectionModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/14/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation

enum HomeSectionModel: SectionModelType {
    case answers(title: String, items: [AnswerCellViewModel])
}

extension HomeSectionModel {
    typealias Item = AnswerCellViewModel
    
    
    var items: [Item] {
        switch self {
        case let .answers(_, items):
            return items
        }
    }
    
    public init(original: HomeSectionModel, items: [Item]) {
        self = original
    }
    
}

protocol ViewModelType {
    
}

protocol ViewModelDidComplete: class {
    func didCompleteLoading()
}

struct AnswerCellViewModel {
    let question: String
    let videoURL: URL
    let thumbnailURL: URL
    let questionUserName: String
    let answerUserName: String
    let questionUserImageURL: URL?
    let answerUserImageURL: URL?
    let answerId: Int
}
