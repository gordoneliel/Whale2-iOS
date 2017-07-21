//
//  VideoPlayerViewModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/12/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import UIKit

struct VideoPlayerViewModel {
    let selectedAnswer: AnswerCellViewModel
    let answers: [AnswerCellViewModel]
    let videoURLS: [URL]
    let selectedVideoURL: URL
    
    init(selectedAnswer: AnswerCellViewModel, answerViewModels: [AnswerCellViewModel]) {
        self.selectedAnswer = selectedAnswer
        self.answers = answerViewModels
        
        self.videoURLS = answers.map{$0.videoURL}
        self.selectedVideoURL = selectedAnswer.videoURL
    }
}
