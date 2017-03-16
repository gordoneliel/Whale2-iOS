//
//  AnswerCell.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/6/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit
import Kingfisher

class AnswerCell: UICollectionViewCell {
    
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var questionContent: UILabel!

    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var questionSenderImageView: UIImageView!

    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    @IBOutlet weak var answerUserImageView: UIImageView!
    @IBOutlet weak var answerUserName: UILabel!
    @IBOutlet weak var questionSender: UILabel!
    
    var answerCellViewModel: AnswerCellViewModel? {
        didSet {
            questionContent.text = answerCellViewModel?.question
            questionSender.text = answerCellViewModel?.questionUserName
            answerUserName.text = answerCellViewModel?.answerUserName
            videoThumbnailImageView.kf.setImage(with: answerCellViewModel?.thumbnailURL)
            questionSenderImageView.kf.setImage(with: answerCellViewModel?.questionUserImageURL)
            answerUserImageView.kf.setImage(with: answerCellViewModel?.answerUserImageURL)
            likeCount.text = answerCellViewModel?.likeCount
            commentCount.text = answerCellViewModel?.commentCount
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
