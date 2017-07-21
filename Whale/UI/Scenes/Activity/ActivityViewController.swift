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
        
        activityViewModel.activityViewController = self
        self.edgesForExtendedLayout = []
        
        skinCollectionView()
    }
    
    func skinCollectionView() {
        
        collectionView.dataSource = nil
        collectionView.delegate = nil
        
        collectionView.dataSource = activityViewModel.dataSource
        activityViewModel.delegate = self
        
        collectionView.register(ActivityQuestionCell.self)
        collectionView.register(ActivityFollowCell.self)
        collectionView.registerSupplementary(GenericHeaderCell.self, kind: UICollectionElementKindSectionHeader)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let layout = ListLayout(
            size: CGSize(
                width: screenWidth,
                height: 100
            ),
            insets: UIEdgeInsets(top: 25, left: 0, bottom: 15, right: 0),
            headerSize: CGSize(
                width: screenWidth,
                height: 70
            ),
            spacing: 25
        )
        
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        
        collectionView.collectionViewLayout = layout
        
        collectionView.refreshControl = UIRefreshControl()
    }
}

extension ActivityViewController: AnswerCellDelegate {
    func didTapAnswer(answer: SectionItem) {
        switch answer {
        case .FollowCellItem:
            break
        case let .MyQuestionItem(question, _, _, questionId):
            let videoEditor = VideoEditingViewController(nibName: VideoEditingViewController.storyboardIdentifier, bundle: nil)
            let navigation = UINavigationController(rootViewController: videoEditor)
            navigation.isNavigationBarHidden = true
            videoEditor.videoEditingViewModel = VideoEditingViewModel(question: question, questionId: questionId)
            
            self.present(navigation, animated: true, completion: nil)
        }
        
    }
}

extension ActivityViewController: ViewModelDidComplete {
    func didCompleteLoading() {
        collectionView.reloadData()
    }
}
