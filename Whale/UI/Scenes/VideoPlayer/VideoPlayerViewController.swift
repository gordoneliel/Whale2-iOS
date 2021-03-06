//
//  VideoPlayerViewController.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/9/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var commentCount: UIButton!
    @IBOutlet weak var likeCount: UIButton!
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
        likeCount.setTitle(videoPlayerViewModel?.selectedAnswer.likeCount, for: .normal)
        commentCount.setTitle(videoPlayerViewModel?.selectedAnswer.commentCount, for: .normal)
        
        videoPlayerView.videoURLs = (viewModel.selectedVideoURL, viewModel.videoURLS)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        videoPlayerView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPlayerView.pause()
    }

    @IBAction func playPressed(_ sender: UIButton) {
        if videoPlayerView.isPlaying {
            videoPlayerView.pause()
        }else {
            videoPlayerView.play()
        }
    }
    
    @IBAction func commentPressed(_ sender: UIButton) {
        
        videoPlayerView.pause()

        let commentVC = CommentViewController(
            nibName: CommentViewController.storyboardIdentifier,
            bundle: nil
        )
        
        commentVC.commentViewModel = CommentViewModel(
            answerCellViewModel: videoPlayerViewModel!.selectedAnswer
        )
        
        show(commentVC, sender: self)
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension VideoPlayerViewController: VideoPlayerDelegate {
    func playerDidStart(progess: Double) {
        progressView.progress = Float(progess)
    }
    
    func playerStarted() {
        playPauseButton.isSelected = false
    }
    
    func playerDidEnd() {
        playPauseButton.isSelected = true
    }
}
