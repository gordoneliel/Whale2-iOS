//
//  ProfleViewController.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/7/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        collectionView.refreshControl?.beginRefreshing()
        profileViewModel.synchronizer.sync {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func setup() {
        collectionView.register(UserProfileCell.self)
        
        profileViewModel.delegate = self
        collectionView.dataSource = profileViewModel.dataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = ListLayout(
            size: CGSize(
                width: UIScreen.main.bounds.size.width,
                height: 180
            ),
            insets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
            headerSize: CGSize.zero
        )
        collectionView.refreshControl = UIRefreshControl()
    }
}

extension ProfileViewController: ViewModelDidComplete {
    func didCompleteLoading() {
        collectionView.reloadData()
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
