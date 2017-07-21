//
//  ActivityQuestionCell.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/15/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

protocol AnswerCellDelegate: class {
    func didTapAnswer(answer: SectionItem)
}

class ActivityQuestionCell: UICollectionViewCell {
    
    @IBOutlet weak var questionUserCategory: UILabel!
    @IBOutlet weak var questionUserName: UILabel!
    @IBOutlet weak var questionUserImageView: CircularImageView!
    @IBOutlet weak var question: UILabel!
    weak var delegate: AnswerCellDelegate?
    
    var viewModel: SectionItem? {
        didSet {
            
            switch viewModel! {
            case let .MyQuestionItem(myQuestion, user, image, _):
                question.text = myQuestion
                questionUserName.text = user
                questionUserImageView.kf.setImage(with: image)
            default:
                break
            }
            
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
            let attr = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
            
            
            let desiredHeight: CGFloat = self.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            attr.frame.size.width = UIScreen.main.bounds.size.width
            attr.frame.size.height = desiredHeight
//            self.frame = attr.frame
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
            return attr
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        guard let answer = viewModel else {return}
        
        delegate?.didTapAnswer(answer: answer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
}
