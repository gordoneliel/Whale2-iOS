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
    func playerDidStart(currentTime: Double)
}

@IBDesignable
class VideoPlayerView: UIView {
    
    @IBInspectable public var timeDisplayColor: UIColor = UIColor.green
    
    fileprivate var timeDisplayLayer: CAShapeLayer = CAShapeLayer()
    
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
    
    public var interval = CMTimeMake(1, 60) {
        didSet {
        }
    }
    
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
    
    fileprivate var timeObserverToken: Any?
    
    open var videoGravity = AVLayerVideoGravityResizeAspectFill {
        didSet {
            self.playerLayer?.videoGravity = videoGravity
        }
    }
    
    fileprivate var playerLayer: AVPlayerLayer?
    
    fileprivate func onSetVideoURL() {
        self.configPlayer()
    }
    
    fileprivate func configPlayer() {
        self.playerItems = videoURLs.videos.map{AVPlayerItem(url: $0)}
        
        self.player = AVQueuePlayer(items: self.playerItems!)
        
        self.player.addObserver(
            self,
            forKeyPath: "rate",
            options: NSKeyValueObservingOptions.new,
            context: nil
        )
        
        self.playerLooper = AVPlayerLooper(player: self.player, templateItem: AVPlayerItem(url: videoURLs.template))
        
        self.playerLayer = AVPlayerLayer(player: player)
        
        self.playerLayer!.videoGravity = videoGravity
        
        self.layer.insertSublayer(timeDisplayLayer, at: 0)
        self.layer.insertSublayer(playerLayer!, below: timeDisplayLayer)
        
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
            }
        }
    }
    
    fileprivate func addTimeObserver() {
        self.timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time -> Void in
            guard let `self` = self else {return}
            self.delegate?.playerDidStart(currentTime: self.currentTime)
        }
    }
    
    // MARK: - Actions
    open func play() {
        player.play()
    }
    
    fileprivate func removeTimeObserver() {
        guard let timeObserverToken = timeObserverToken else {return}
        self.timeObserverToken = nil
        player.removeTimeObserver(timeObserverToken)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.player.removeObserver(self, forKeyPath: "rate")
        removeTimeObserver()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds
    }
    
    open func pause() {
        player.pause()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createDisplayLink()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createDisplayLink()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawTimeDisplay()
    }
    
    func createDisplayLink() {
        // Display link syncs up the current progress of the video to the progress bar at the native frame rate
        let displayLink = CADisplayLink(target: self, selector: #selector(self.displayLinkSync))
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
    }
}

// Current time display
extension VideoPlayerView {
    func drawTimeDisplay() {
        // Path
        let timePath = UIBezierPath()
        timePath.move(to: CGPoint(x: 0, y: self.bounds.maxY))
        timePath.addLine(to: CGPoint(x: self.frame.maxX, y: self.bounds.maxY))
        
        timeDisplayLayer.lineWidth = 6
        timeDisplayLayer.strokeColor = timeDisplayColor.cgColor
        timeDisplayLayer.path = timePath.cgPath
        
    }
    
    @objc func displayLinkSync() {
        guard let maxTime = player.currentItem?.duration.seconds else {return}
        
        timeDisplayLayer.strokeEnd = CGFloat((currentTime) / maxTime)
    }
}

