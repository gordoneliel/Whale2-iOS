//
//  VideoEditingToolbar.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/16/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class VideoEditingToolbar: UIView {
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var collectionView: UICollectionView!
    var videoSegments: [VideoSegment] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = ListLayout(
            size: CGSize(width: 80, height: 80),
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            spacing: 10,
            scrollDirection: .horizontal
        )
        
        collectionView.register(VideoSegmentCell.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("VideoEditingToolbar", owner: self, options: nil)
        
        // 2. Add the 'contentView' to self
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // 4. Setup constraints
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

}

extension VideoEditingToolbar: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoSegments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as VideoSegmentCell
        
        cell.thumbnailImageView.image = videoSegments[indexPath.row].previewImage
        
        return cell
    }
}
