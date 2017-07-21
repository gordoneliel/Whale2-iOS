//
//  VideoEditingViewModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/30/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation

struct VideoEditingViewModel {
    let question: String
    let questionId: Int
    
    init(question: String, questionId: Int) {
        self.question = question
        self.questionId = questionId
    }
}
