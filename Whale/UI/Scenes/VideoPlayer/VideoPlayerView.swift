//
//  VideoPlayerView.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/9/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol VideoPlayerDelegate: class {
    func playerDidEnd()
    func playerDidStart(progess: Double)
    func playerStarted()
}

@IBDesignable
class VideoPlayerView: UIView {
    
    weak var delegate: VideoPlayerDelegate?
    
    open var videoURLs: (template: URL, videos: [URL])! {
        didSet { onSetVideoURL() }
    }
    
    open var playerItems: [AVPlayerItem]?
    
    lazy var player: AVQueuePlayer = {
        let player = AVQueuePlayer(items: self.playerItems ?? [])
        return player
    }()
    
    open var playerLooper: AVPlayerLooper?
    
    open var isPlaying: Bool {
        get {
            return player.rate > 0.0
        }
    }
    
    public var interval = CMTimeMake(1, 60)
    
    public var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            guard let timescale = player
                .currentItem?
                .duration
                .timescale
                else {return}
            
            let newTime = CMTimeMakeWithSeconds(newValue, timescale)
            player.seek(to: newTime,toleranceBefore: kCMTimeZero,toleranceAfter: kCMTimeZero)
        }
    }
    
    
    public var totalTime: Double {
        get {
            guard let duration = player.currentItem?.duration else {return 0}
            
            return CMTimeGetSeconds(duration)
        }
    }
    
    public var progress: Double {
        return currentTime / totalTime
    }
    
    fileprivate var timeObserverToken: Any?
    
    open var videoGravity = AVLayerVideoGravityResizeAspectFill {
        didSet {
            self.playerLayer.videoGravity = videoGravity
        }
    }
    
    fileprivate var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    fileprivate func onSetVideoURL() {
        self.configPlayer()
    }
    
    fileprivate func configPlayer() {
        self.playerItems = videoURLs.videos.map{AVPlayerItem(url: $0)}
        
        self.player = AVQueuePlayer(items: self.playerItems!)
        self.player.actionAtItemEnd = .advance

        self.player.addObserver(
            self,
            forKeyPath: "rate",
            options: NSKeyValueObservingOptions.new,
            context: nil
        )

        self.playerLooper = AVPlayerLooper(
            player: self.player,
            templateItem: AVPlayerItem(url: videoURLs.template)
        )
        
        
        self.playerLayer.videoGravity = videoGravity
        self.playerLayer.player = player
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            guard let newRate = change?[NSKeyValueChangeKey.newKey] as? NSNumber else {return}
            self.addTimeObserver()
            
            if newRate.floatValue <= 0 {
                removeTimeObserver()
                delegate?.playerDidEnd()
            }else {
                delegate?.playerStarted()
            }
            player.seek(to: kCMTimeZero)
        }
    }
    
    fileprivate func addTimeObserver() {
        self.timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time -> Void in
            guard let `self` = self else {return}
            self.delegate?.playerDidStart(progess: self.progress)
        }
    }
    
    // MARK: - Actions
    open func play() {
        player.play()
    }
    
    fileprivate func removeTimeObserver() {
        guard let timeObserverToken = self.timeObserverToken else {return}
        self.timeObserverToken = nil
        player.removeTimeObserver(timeObserverToken)
    }
    
    deinit {
        self.player.removeObserver(self, forKeyPath: "rate")
        removeTimeObserver()
    }
    
    open func pause() {
        player.pause()
    }
}

