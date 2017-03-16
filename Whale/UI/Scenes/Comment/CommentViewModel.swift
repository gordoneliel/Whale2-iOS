//
//  CommentViewModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/13/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation

class CommentViewModel {
    let answerCellViewModel: AnswerCellViewModel
    
    let dataSource = SectionedDataSource<CommentSectionModel>()
    let networking = BaseNetworking.newNetworking()
    let queue = OperationQueue()
    weak var delegate: ViewModelDidComplete?
    
    var pagination: PaginationViewModel<JSONComment>
    var paginationState: PaginationState = .loading(page: 0, pageSize: 6)
    
    init(answerCellViewModel: AnswerCellViewModel) {
        self.answerCellViewModel = answerCellViewModel
        
         pagination = PaginationViewModel<JSONComment>(page: 0, pageSize: 3)
        
        // Datasource
        dataSource.configureCell = { dataSource, cv, indexPath, item in
            let cell = cv.dequeueReusableCell(forIndexPath: indexPath) as CommentCell
            
            cell.viewModel = item
            
            return cell
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
