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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
