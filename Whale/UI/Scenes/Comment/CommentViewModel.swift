//
//  CommentViewModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/13/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation

enum UIState {
    case success
    case error
    case nodata
}

class CommentViewModel {
    let answerCellViewModel: AnswerCellViewModel
    
    let dataSource = SectionedDataSource<CommentSectionModel>()
    let networking = BaseNetworking.newNetworking()
    let queue = OperationQueue()
    weak var delegate: ViewModelDidComplete?
    let headerTitle = "Comments"
    
    var pagination: PaginationViewModel<JSONComment>
    var paginationState: PaginationState = .loading(page: 0, pageSize: 10)
    
    init(answerCellViewModel: AnswerCellViewModel) {
        self.answerCellViewModel = answerCellViewModel
        
         pagination = PaginationViewModel<JSONComment>()
        
        // Datasource
        dataSource.configureCell = { dataSource, cv, indexPath, item in
            let cell = cv.dequeueReusableCell(forIndexPath: indexPath) as CommentCell
            
            cell.viewModel = item
            
            return cell
        }
    }
    
    func postComment(content: String, completionBlock: @escaping (_ state: UIState) -> Void) {
        networking.request(CoreApiClient.createComment(answerId: answerCellViewModel.answerId, content: content)) { completion in
            switch completion {
            case let .success(response):
                var uiState = UIState.error
                
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    uiState = UIState.success
                }catch {
                    uiState = UIState.error
                }
                
                completionBlock(uiState)
            case .failure(_):
                let errorState = UIState.error
                completionBlock(errorState)
            }
        }
    }
    
    func loadNextPage() {
        // From nextIdle to loading
        let pageState = paginationState.next()
        
        let newRequest = CoreApiClient.comments(
            answerId: answerCellViewModel.answerId,
            page: pageState.paginationValue().page,
            pageSize: pageState.paginationValue().pageSize
        )
        
        pagination.paginate(request: newRequest) { [unowned
            self] in
            defer {
                self.delegate?.didCompleteLoading()
                self.paginationState = .nextIdle(
                    page: self.pagination.currentPage,
                    pageSize: self.pagination.pageSize
                )
                if self.pagination.isFinalPage {
                    self.paginationState = .loadedAllPages
                }
                
            }
            
            guard let jsonComments = self.pagination.pageData?.data else {return}
            
            guard !jsonComments.isEmpty else {return}
            
            let items = jsonComments.map { comment in
                return CommentCellViewModel(
                    user: "\(comment.commenter.firstName) \(comment.commenter.lastName)",
                    userImage: comment.commenter.profileImageUrl,
                    comment: comment.content
                )
            }
            

            guard let existing = self.dataSource.sectionModels.first else {
                let section = CommentSectionModel(header: "Comments", items: items)
                self.dataSource.setSections([section])
                return
            }
            
            let newCollection = existing.items + items
            
            let newSection = CommentSectionModel(header: "Comments", items: newCollection)
            
            self.dataSource.setSections([newSection])
        }
    }
    
    func canLoadNext() -> Bool {
        return paginationState == PaginationState.nextIdle(page: 0, pageSize: 0)
    }
}
