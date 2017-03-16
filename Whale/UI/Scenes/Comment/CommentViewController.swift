//
//  CommentViewController.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/12/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var commentViewModel: CommentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = nil
        collectionView.delegate = self
        
        guard let viewModel = commentViewModel else {return}
        
        collectionView.collectionViewLayout = ListLayout(
            size: CGSize(width: UIScreen.main.bounds.width, height: 65),
            insets: UIEdgeInsets.zero,
            spacing: 10
        )
        
        collectionView.dataSource = viewModel.dataSource
        collectionView.register(CommentCell.self)
        viewModel.delegate = self
        
        viewModel.loadNextPage()
    }
}

extension CommentViewController: ViewModelDidComplete {
    func didCompleteLoading() {
        collectionView.reloadData()
    }
}

extension CommentViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isNearBottomEdge() && commentViewModel!.canLoadNext() {
            commentViewModel!.loadNextPage()
        }
    }
}
