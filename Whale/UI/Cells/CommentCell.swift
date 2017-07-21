//
//  CommentCell.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/13/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {

    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var viewModel: CommentCellViewModel? {
        didSet {
            userName.text = viewModel?.user
            userImageView.kf.setImage(with: viewModel?.userImage)
            comment.text = viewModel?.comment
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
            let attr = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
            
            
            let desiredHeight: CGFloat = self.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            attr.frame.size.width = UIScreen.main.bounds.size.width
            attr.frame.size.height = desiredHeight
            self.frame = attr.frame
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
            return attr
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
