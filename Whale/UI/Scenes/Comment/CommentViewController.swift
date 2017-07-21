//
//  CommentViewController.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/12/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var commentViewModel: CommentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = nil
        collectionView.delegate = self
        
        // Comment TextField
        commentTextField.delegate = self
        registerKeyboardObservers()
        
        guard let viewModel = commentViewModel else {return}
        
        headerTitle.text = viewModel.headerTitle
        
        let layout = ListLayout(
            size: CGSize(width: UIScreen.main.bounds.width, height: 65),
            insets: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0),
            spacing: 10
        )
        
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize

        collectionView.collectionViewLayout = layout
        collectionView.dataSource = viewModel.dataSource
        collectionView.register(CommentCell.self)
        viewModel.delegate = self
        
        viewModel.loadNextPage()
        
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        commentTextField.resignFirstResponder()
        guard let content = commentTextField.text else {return}
        
        commentViewModel?.postComment(content: content) { [weak self] state in
            switch state {
            case .success:
                self?.commentTextField.text = nil
            default:
                break
            }
        }
    }
    
    func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.handleKeyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.handleKeyboardShow), name: NSNotification.Name.UIKeyboardWillHide,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.handleKeyboardShow), name: NSNotification.Name.UIKeyboardWillChangeFrame,object: nil)
        
    }
    
    func handleKeyboardShow(notification: Notification) {
        guard let frameNSValue = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue
        else {return}
        
        let frame = frameNSValue.cgRectValue
        
        commentBarBottomConstraint.constant = frame.height
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CommentViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        commentBarBottomConstraint.constant = 0
    }
}

extension CommentViewController: ViewModelDidComplete {
    func didCompleteLoading() {
        collectionView.reloadData()
    }
}

extension CommentViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        commentTextField.resignFirstResponder()
        
        // Pagination
        if scrollView.isNearBottomEdge() && commentViewModel!.canLoadNext() {
            commentViewModel!.loadNextPage()
        }
    }
}
