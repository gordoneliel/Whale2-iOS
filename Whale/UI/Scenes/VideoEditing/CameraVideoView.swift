//
//  CameraVideoView.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/16/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoRecordingDelegate: class {
    func didFinishRecording(thumbnail: UIImage?, videoURL: URL?)
}

class CameraVideoView: UIView {
    
    var captureSession: AVCaptureSession! {
        get {
            return previewLayer.session
        }
        set {
            previewLayer.session = newValue
        }
    }
    
    var videoDataOutput: AVCaptureVideoDataOutput?
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    private var audioConnection: AVCaptureConnection!
    private var videoConnection: AVCaptureConnection!
    var movieFileOutput: AVCaptureMovieFileOutput?
    var imageOutput = AVCapturePhotoOutput()
    var thumbnailImage: UIImage?
    var videoURL: URL?
    
    weak var recordingDelegate: VideoRecordingDelegate?
    
    override class var layerClass: AnyClass {
        get {
            return AVCaptureVideoPreviewLayer.self
        }
    }
    
    let videoOutputQueue = DispatchQueue(label: "video-segment-queue")
    let audioOutputQueue = DispatchQueue(label: "audio-queue")
    let movieOutputQueue = DispatchQueue(label: "movie-queue")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let frontCamera = AVCaptureDevice.defaultDevice(
            withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera,
            mediaType: AVMediaTypeVideo,
            position: AVCaptureDevicePosition.front
        )

        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput?.setSampleBufferDelegate(self, queue: videoOutputQueue)
            
            captureSession.addOutput(videoDataOutput)
            
            // VideoPreview
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            guard let videoConnection = videoDataOutput?.connection(withMediaType: AVMediaTypeVideo) else {return}
            self.videoConnection = videoConnection
            
            
            captureSession.beginConfiguration()
            let movieFileOutput = AVCaptureMovieFileOutput()
            
            captureSession.addOutput(movieFileOutput)
            guard let movieFileConnection = movieFileOutput.connection(withMediaType: AVMediaTypeVideo) else {return}
            movieFileConnection.preferredVideoStabilizationMode = .auto
            
            // Photo
            do {
                guard captureSession.canAddOutput(imageOutput) else {fatalError()}
                captureSession.addOutput(imageOutput)
            }
            
            captureSession.commitConfiguration()
            
            self.movieFileOutput = movieFileOutput
            
        }catch {
            
        }
        
        // Audio Output
        // setup audio output
        do {
            let audioDataOutput = AVCaptureAudioDataOutput()
            
            audioDataOutput.setSampleBufferDelegate(self, queue: audioOutputQueue)
            guard captureSession.canAddOutput(audioDataOutput) else {fatalError()}
            
            captureSession.addOutput(audioDataOutput)
            
            audioConnection = audioDataOutput.connection(withMediaType: AVMediaTypeAudio)
        }
        
    }
    
    func startRecording() {
        guard let movieFileOutput = self.movieFileOutput else {return}
        
        let videoPreviewLayerOrientation = previewLayer.connection.videoOrientation
        
        let settings = AVCapturePhotoSettings()
        imageOutput.capturePhoto(with: settings, delegate: self)
        
        movieOutputQueue.async {
            guard !movieFileOutput.isRecording else { return movieFileOutput.stopRecording() }
            
            // Update the orientation on the movie file output video connection before starting recording.
            let movieFileOutputConnection = movieFileOutput.connection(withMediaType: AVMediaTypeVideo)
            movieFileOutputConnection?.videoOrientation = videoPreviewLayerOrientation
            
            // Start recording to a temporary file.
            // Store video in temp location so we can delete it
            do {
                let tempVideoURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("temp-videos")
                
                let outputFileName = NSUUID().uuidString
                let tempFileURL = tempVideoURL.appendingPathComponent(outputFileName).appendingPathExtension("mov")
                
                movieFileOutput.startRecording(toOutputFileURL: tempFileURL, recordingDelegate: self)
            }catch {
                
            }
            
            
        }
    }
    
    func stopRecording() {
        movieFileOutput?.stopRecording()
    }
    
    func requestPermission() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authorizationStatus {
        case .notDetermined:
            // permission dialog not yet presented, request authorization
            AVCaptureDevice.requestAccess(
                forMediaType: AVMediaTypeVideo,
                completionHandler: { (granted: Bool) -> Void in
                    if granted {
                        // go ahead
                    }
                    else {
                        // user denied, nothing much to do
                    }
            })
        case .authorized:
            break
        // go ahead
        case .denied,
             .restricted:
            break
            // the user explicitly denied camera usage or is not allowed to access the camera devices
        }
    }
    
    func startSession() {
        guard !captureSession.isRunning else {return}
        captureSession.startRunning()
    }
    
    func stopSession() {
        guard captureSession.isRunning else {return}
        
        captureSession.stopRunning()
    }
    
    func cleanUpTempResources() {

        let tempDir = NSTemporaryDirectory()
        let tempVideoURL = URL(fileURLWithPath: tempDir, isDirectory: true)
            .appendingPathComponent("temp-videos")
        let tempString = tempVideoURL.absoluteString
        
        if FileManager.default.fileExists(atPath: tempString) {
            do {
                try FileManager.default.removeItem(atPath: tempString)
            }
            catch {
                print("Could not remove file)")
            }
        }
    }
    
    deinit {
        cleanUpTempResources()
    }
}

extension CameraVideoView: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
    }
}

extension CameraVideoView: AVCaptureFileOutputRecordingDelegate {
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        
        guard error == nil else {return}
        
        self.videoURL = outputFileURL
        
        recordingDelegate?.didFinishRecording(thumbnail: thumbnailImage, videoURL: videoURL)
    }
}

extension CameraVideoView: AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard error == nil else {return}
        
        guard let sampleBuffer = photoSampleBuffer,
            let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {return}
        
        let thumbnailImage = UIImage(data: dataImage)
        self.thumbnailImage = thumbnailImage
        
    }
}
