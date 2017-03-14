//
//  ActivityViewController.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/7/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit
import Foundation

class ListLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(size: CGSize = CGSize(width: 300, height: 150), insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 30, right: 0), headerSize: CGSize = CGSize(width: 0, height: 0)) {
        self.init()
        commonInit(size: size, insets: insets, headerSize: headerSize)
    }
}

extension ListLayout {
    fileprivate func commonInit(size: CGSize, insets: UIEdgeInsets, headerSize: CGSize) {
        scrollDirection = .vertical
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
//        estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        itemSize = CGSize(width: size.width - (insets.left * 2), height: size.height)
        sectionInset = insets
        headerReferenceSize = headerSize
    }
}
