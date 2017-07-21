//
//  VideoUploadViewModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/23/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Result

struct VideoUploadViewModel {
    let videoSegments: [VideoSegment]
    let compositor: Compositor
    let networking = BaseNetworking.newNetworking()
    let editorViewModel: VideoEditingViewModel
    
    init(segments: [VideoSegment], editorViewModel: VideoEditingViewModel) {
        self.videoSegments = segments
        self.editorViewModel = editorViewModel
        
        let urls = segments.map {$0.videoURL}
        self.compositor = Compositor(urls: urls)
    }
    
    func fetchCompositeVideo(completionBlock: @escaping (Result<URL, CompositorError>) -> Void) {
        let composition = compositor.mixComposition
        return self.compositor.export(asset: composition, completion: completionBlock)
    }
    
    func uploadAnswer() {
        networking.request(CoreApiClient.createAnswer(questionId: editorViewModel.questionId, video: compositor.storageURL, thumbnail: compositor.storageURL)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure:
                break
            }
        }
    }
}
