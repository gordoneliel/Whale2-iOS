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
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
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
    
    let movieOutputQueue = DispatchQueue(label: "movie-queue")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        captureSession = AVCaptureSession()
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        // VideoPreview
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
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
            
            let movieFileOutput = AVCaptureMovieFileOutput()
            
            captureSession.addOutput(movieFileOutput)
            
            guard let movieFileConnection = movieFileOutput.connection(withMediaType: AVMediaTypeVideo) else {return}
            movieFileConnection.preferredVideoStabilizationMode = .auto
            movieFileConnection.videoOrientation = .portrait
            
            // Photo
            do {
                guard captureSession.canAddOutput(imageOutput) else {fatalError()}
                captureSession.addOutput(imageOutput)
            }
            
            self.movieFileOutput = movieFileOutput
            
        }catch {
            
        }
        
        // Audio Output
        // setup audio output
        var audioInput: AVCaptureDeviceInput!
        do {
            let micDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
            
            audioInput = try AVCaptureDeviceInput(device: micDevice)
            
            guard captureSession.canAddInput(audioInput)
                else {fatalError()}
            
            captureSession.addInput(audioInput)
            
        }catch {
            
        }
        
    }
    
    func startRecording() {
        guard let movieFileOutput = self.movieFileOutput else {return}
        
        let settings = AVCapturePhotoSettings()
        
        imageOutput.capturePhoto(with: settings, delegate: self)
        
        movieOutputQueue.async {
            guard !movieFileOutput.isRecording else { return movieFileOutput.stopRecording() }
            
            // Start recording to a temporary file.
            // Store video in temp location so we can delete it
            
            let tempVideoURL = FileManager.default.temporaryDirectory
            let outputFileName = NSUUID().uuidString
            let tempFileURL = tempVideoURL.appendingPathComponent(outputFileName).appendingPathExtension("mov")
            
            movieFileOutput.startRecording(toOutputFileURL: tempFileURL, recordingDelegate: self)
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
    
    // Deletes the temporary folder and recreates it
    func cleanUpTempResources() {
        do {
            let tempURL = FileManager.default.temporaryDirectory
            try FileManager.default.removeItem(at: tempURL)
            try FileManager.default.createDirectory(at: tempURL, withIntermediateDirectories: false, attributes: nil)
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    deinit {
        cleanUpTempResources()
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
