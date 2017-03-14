//
//  HomeViewController.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/7/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        collectionView.register(AnswerCell.self)
        collectionView.registerSupplementary(GenericHeaderCell.self, kind: UICollectionElementKindSectionHeader)
        
        collectionView.dataSource = viewModel.dataSource
        collectionView.delegate = self
        let screenWidth = UIScreen.main.bounds.size.width
        collectionView.collectionViewLayout = ListLayout(
            size: CGSize(
                width: screenWidth,
                height: 300
            ),
            headerSize: CGSize(width: screenWidth, height: 60)
        )
        
        collectionView.refreshControl = UIRefreshControl()
        
        viewModel.loadNextPage()
    }
    
    @IBAction func unwindChildViewController(segue: UIStoryboardSegue) {
        segue.source.dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = viewModel.dataSource.sectionModels[indexPath.section].items[indexPath.row]
        
        viewModel.selectedItem = selectedItem
        
        performSegue(withIdentifier: "videoSegue", sender: self)
    }
}

extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "videoSegue",
            let destination = segue.destination as? VideoPlayerViewController,
            let selectedItem = viewModel.selectedItem
            else {return}
        
        destination.videoPlayerViewModel = VideoPlayerViewModel(
            selectedAnswer: selectedItem,
            answerViewModels: viewModel.answers
        )
    }
}

extension HomeViewController: ViewModelDidComplete {
    
    func didCompleteLoading() {
        collectionView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isNearBottomEdge() && viewModel.canLoadNext() {
            viewModel.loadNextPage()
        }
    }
}
