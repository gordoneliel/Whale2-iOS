//
//  VideoUploadViewController.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/18/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class VideoUploadViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    
    var uploadViewModel: VideoUploadViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
        
        videoPlayerView.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uploadViewModel = uploadViewModel else {return}
        videoPlayerView.delegate = self
        
        activityIndicator.startAnimating()
        uploadViewModel.fetchCompositeVideo { [unowned self] result in
            self.activityIndicator.stopAnimating()
            
            switch result {
            case let .success(url):
                self.videoPlayerView.videoURLs = (url, [url])
                self.videoPlayerView.play()
            case .failure:
                break
            }
        }
    }
    
    @IBAction func uploadPressed(_ sender: UIButton) {
        uploadViewModel?.uploadAnswer()
    }
}

extension VideoUploadViewController: VideoPlayerDelegate {
    func playerDidStart(progess: Double) {
        print(progess)
    }
    
    func playerStarted() {
        
    }
    func playerDidEnd() {

    }
}
