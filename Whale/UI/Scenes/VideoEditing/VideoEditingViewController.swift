//
//  VideoEditingViewController.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/16/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class VideoEditingViewController: UIViewController {
    @IBOutlet weak var cameraPreview: CameraVideoView!
    @IBOutlet weak var editingSegmentsToolbar: VideoEditingToolbar!
    var videoSegments: [VideoSegment] = [] {
        didSet {
            editingSegmentsToolbar.videoSegments = videoSegments
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraPreview.recordingDelegate = self
        
        cameraPreview.startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraPreview.stopSession()
    }
    
    @IBAction func recordSegmentPressed(_ sender: UIButton) {
        guard let movieFileOutput = cameraPreview.movieFileOutput else {return}
        
        if movieFileOutput.isRecording {
            cameraPreview.stopRecording()
        }else {
            cameraPreview.startRecording()
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let videoUploadVC = VideoUploadViewController(nibName: VideoUploadViewController.storyboardIdentifier, bundle: nil)
        present(videoUploadVC, animated: true, completion: nil)
    }
    
}

extension VideoEditingViewController: VideoRecordingDelegate {
    func didFinishRecording(thumbnail: UIImage?, videoURL: URL?) {
        guard let thumbnail = thumbnail, let videoURL = videoURL else {return}
        
        let videoSegment = VideoSegment(videoURL: videoURL, previewImage: thumbnail)
        videoSegments.append(videoSegment)
    }
}
