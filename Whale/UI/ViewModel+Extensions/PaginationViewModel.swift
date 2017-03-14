//
//  PaginationViewModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/14/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Gloss

class PaginationViewModel<T: Decodable> {
    var currentPage = 0
    var pageSize = 50
    var pageData: PageData<T>?
    let networking = BaseNetworking.newNetworking()
    var isFinalPage = false
    let semphore = DispatchSemaphore(value: 1)
    var loading: Bool = false
    
    init(page: Int, pageSize: Int) {
        self.currentPage = page
        self.pageSize = pageSize
    }
    
    func paginate(request: CoreApiClient, _ completionBlock: @escaping () -> Void) {
        // Wait until we are done with pagination
        if !loading {
            
           self.loading = true
            DispatchQueue.global().async {
                
                self.startRequest(request: request) { [unowned self] (pageData) in
                    guard pageData.page <= pageData.totalPages else {
                        self.isFinalPage = true
                        self.pageData = nil
                        return
                    }
                    
                    self.pageData = pageData
                    self.currentPage = pageData.page + 1
                    
                    self.loading = false
                    completionBlock()
                }
            }
        }
    }
    
    private func startRequest(request: CoreApiClient, completionBlock: @escaping (_ pageData: PageData<T>) -> Void) {
        networking.request(request) { completion in
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
