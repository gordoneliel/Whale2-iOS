//
//  CircularImageView.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/12/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CircularImageView: UIImageView {
    
    @IBInspectable var circular: Bool = true {
        didSet {
            self.layer.cornerRadius = self.frame.size.width / 2
            self.clipsToBounds = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    

}
