//
//  Compositor.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/24/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import AVFoundation
import Result

import Photos
import AssetsLibrary

enum CompositorError: Error {
    case couldNotExport
}

struct Compositor {
    
    var storageURL: URL {
        return FileManager.default.temporaryDirectory
    }
    
    var tempFileName: String {
        return UUID().uuidString
    }
    
    var mixComposition: AVMutableComposition
    
    init(urls: [URL]) {
        
        let assets = urls.map {AVAsset(url: $0)}
        
        let composition = AVMutableComposition()
        
        self.mixComposition = Compositor.addTracks(assets: assets, composition: composition)
    }
    
    static func addTracks(assets: [AVAsset], composition: AVMutableComposition) -> AVMutableComposition {
        
        let videoTrack = composition.addMutableTrack(
            withMediaType: AVMediaTypeVideo,
            preferredTrackID: kCMPersistentTrackID_Invalid
        )
        
        let audioTrack = composition.addMutableTrack(
            withMediaType: AVMediaTypeAudio,
            preferredTrackID: kCMPersistentTrackID_Invalid
        )
        
        var totalDuration = kCMTimeZero
        
        assets.forEach { (asset) in
            do {
                try videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration),
                                               of: asset.tracks(withMediaType: AVMediaTypeVideo)[0],
                                               at: totalDuration)
                
                try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration),
                                               of: asset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                               at: totalDuration)
                
                totalDuration = CMTimeAdd(totalDuration, asset.duration)
            } catch let error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        
        // Need to rotate video because AVFoundation records in landscape
        videoTrack.preferredTransform = CGAffineTransform(rotationAngle: .pi / 2)
        
        return composition
    }
    
    /*
     Exports an asset to the export url
     */
    func export(asset: AVAsset, completion: @escaping (Result<URL, CompositorError>) -> Void) {
        
        let exporter = AVAssetExportSession(
            asset: asset,
            presetName: AVAssetExportPresetHighestQuality
        )
        exporter?.outputURL = storageURL
            .appendingPathComponent(tempFileName)
            .appendingPathExtension("mov")
        
        exporter?.outputFileType = AVFileTypeQuickTimeMovie
        exporter?.shouldOptimizeForNetworkUse = true
        
        exporter?.exportAsynchronously {
            DispatchQueue.main.async {
                guard let exportUrl = exporter?.outputURL else {return completion(.failure(CompositorError.couldNotExport))}
                
                completion(.success(exportUrl))
            }
        }
        
    }
}
