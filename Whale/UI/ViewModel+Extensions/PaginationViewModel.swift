//
//  PaginationViewModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/14/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Gloss

enum PaginationState {
    case nextIdle(page: Int, pageSize: Int)
    case loadedAllPages
    case loading(page: Int, pageSize: Int)
}

extension PaginationState {
    func paginationValue() -> (page: Int, pageSize: Int) {
        switch self {
        case let .nextIdle(page, pageSize), let .loading(page, pageSize):
            return (page, pageSize)
        default:
            return (0, 0)
        }
    }
    
    func next() -> PaginationState {
        switch self {
        case let .nextIdle(page, pageSize):
            return .loading(page: page, pageSize: pageSize)
        case let .loading(page, pageSize):
            return .nextIdle(page: page, pageSize: pageSize)
        default:
            return .loadedAllPages
        }
    }
}

extension PaginationState: Equatable {}

func ==(lhs: PaginationState, rhs: PaginationState) -> Bool {
    switch (lhs, rhs) {
    case (.nextIdle(_, _), .nextIdle(_, _)):
        return true
    case (.loading(_, _), .loading(_, _)):
        return true
    case (.loadedAllPages, .loadedAllPages):
        return true
    default:
        return false
    }
}

class PaginationViewModel<T: Gloss.Decodable> {
    var currentPage = 0
    var pageSize = 50
    var pageData: PageData<T>?
    let networking = BaseNetworking.newNetworking()
    var isFinalPage = false
    var loading: Bool = false
    
    init() {
    }
    
    /*
     Paginates a network request
     Blocks requests till previous request is completed, presents data on the main queue
     */
    func paginate(request: CoreApiClient, _ completionBlock: @escaping () -> Void) {
        // Wait until we are done with pagination
        if !loading && !isFinalPage {
            
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
                    self.pageSize = pageData.perPage
                    
                    DispatchQueue.main.async {
                        self.loading = false
                        completionBlock()
                    }
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
