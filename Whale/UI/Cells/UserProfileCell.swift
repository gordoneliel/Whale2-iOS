//
//  UserProfileCell.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/11/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class UserProfileCell: UICollectionViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var askQuestionButton: UIButton!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var askFollowStackView: UIStackView!
    
    var userProfileCellViewModel: UserProfileCellViewModel? {
        didSet {
            profileImageView.kf.setImage(with: userProfileCellViewModel?.imageURL)
            userName.text = userProfileCellViewModel?.name
            followLabel.text = userProfileCellViewModel?.followCount
            askFollowStackView.isHidden = userProfileCellViewModel?.personal ?? true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
