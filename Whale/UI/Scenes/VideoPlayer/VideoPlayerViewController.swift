//
//  VideoPlayerViewController.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/9/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var questionUserImage: UIImageView!
    @IBOutlet weak var questionUser: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    @IBOutlet weak var question: UILabel!
    
    var videoPlayerViewModel: VideoPlayerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = videoPlayerViewModel else {return}
        
        videoPlayerView.delegate = self
        
        question.text = videoPlayerViewModel?.selectedAnswer.question
        questionUser.text = videoPlayerViewModel?.selectedAnswer.questionUserName
        questionUserImage.kf.setImage(with: videoPlayerViewModel?.selectedAnswer.questionUserImageURL)
        
        videoPlayerView.videoURLs = (viewModel.selectedAnswer.videoURL, viewModel.answers.map{$0.videoURL})
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        videoPlayerView.play()
    }

    @IBAction func playPressed(_ sender: UIButton) {
        if videoPlayerView.isPlaying {
            videoPlayerView.pause()
            sender.isSelected = true
        }else {
            videoPlayerView.play()
            sender.isSelected = false
        }
    }
    
    @IBAction func commentPressed(_ sender: UIButton) {
        
        videoPlayerView.pause()
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: CommentViewController.storyboardIdentifier)
        
        guard let commentVC = vc as? CommentViewController,
            let answerCellViewModel = videoPlayerViewModel?.selectedAnswer else {return}
        
        commentVC.commentViewModel = CommentViewModel(answerCellViewModel: answerCellViewModel)
        
        show(commentVC, sender: self)
    }
    
    
}

extension VideoPlayerViewController: VideoPlayerDelegate {
    func playerDidStart(currentTime: Double) {
        print(currentTime)
    }
    
    func playerDidEnd() {
        playPauseButton.isSelected = true
    }
}
