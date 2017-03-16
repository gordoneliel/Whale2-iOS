//
//  ActivityViewController.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/7/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var activityViewModel = ActivityViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skinCollectionView()
    }
    
    func skinCollectionView() {
        
        collectionView.dataSource = nil
        collectionView.delegate = nil
        
        collectionView.register(ActivityQuestionCell.self)
        collectionView.register(ActivityFollowCell.self)
        collectionView.registerSupplementary(GenericHeaderCell.self, kind: UICollectionElementKindSectionHeader)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let layout = ListLayout(
            size: CGSize(
                width: screenWidth,
                height: 100
            ),
            insets: UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0),
            headerSize: CGSize(
                width: screenWidth,
                height: 65
            ),
            spacing: 25
        )
        
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        
        collectionView.collectionViewLayout = layout
        
        collectionView.refreshControl = UIRefreshControl()
        
        collectionView.dataSource = activityViewModel.dataSource
        activityViewModel.delegate = self
    }
}

extension ActivityViewController: ViewModelDidComplete {
    func didCompleteLoading() {
        collectionView.reloadData()
    }
}
