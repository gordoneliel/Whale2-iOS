//
//  HomeOperation.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/9/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//
import Gloss
import Foundation

class DownloadOperation<T: Decodable>: AsyncOperation {
    var currentPage = 0
    var pageSize = 50
    var pageData: PageData<T>?
    let networking = BaseNetworking.newNetworking()
    let apiClient: CoreApiClient
    var isFinalPage = false
    
    init(page: Int, pageSize: Int, apiClient: CoreApiClient) {
        self.currentPage = page
        self.pageSize = pageSize
        self.apiClient = apiClient
    }
    
    override func start() {
        self.isExecuting = true
        self.isFinished = false
        
        if !self.isCancelled {
            startRequest { [unowned self] (pageData) in
                defer {
                    self.isExecuting = false
                    self.isFinished = true
                }
                
                guard pageData.page <= pageData.totalPages else {
                    self.isFinalPage = true
                    return
                }
                
                self.pageData = pageData
                self.currentPage = pageData.page + 1
            }
        }
        
    }
    
    fileprivate func startRequest(completionBlock: @escaping (_ pageData: PageData<T>) -> Void) {
        networking.request(apiClient) { completion in
            switch completion {
            case let .success(response):
                do {
                    let serverPageData = try response.mapTo(PageData<T>.self)
                    completionBlock(serverPageData)
                } catch let error {
                    print(error)
                }
                
            case .failure(_):
                break
            }
        }
    }
}
