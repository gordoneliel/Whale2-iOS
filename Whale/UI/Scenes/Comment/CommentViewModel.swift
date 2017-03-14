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
    
    init(answerCellViewModel: AnswerCellViewModel) {
        self.answerCellViewModel = answerCellViewModel
        
        let downloadOp = DownloadOperation<JSONComment>(
            page: 0,
            pageSize: 50,
            apiClient: CoreApiClient.comments(
                answerId: answerCellViewModel.answerId,
                page: 0,
                pageSize: 50
            )
        )
        
        queue.addOperation(downloadOp)
        
        downloadOp.completionBlock = {
            guard let pageData = downloadOp.pageData else {return}
            
            let comments = pageData.data.map {
                return CommentCellViewModel(
                    user: "\($0.commenter.firstName) \($0.commenter.lastName)",
                    userImage: $0.commenter.profileImageUrl,
                    comment: $0.content
                )
            }
            
            let sectionModel = CommentSectionModel(header: "Comment", items: comments)
            self.dataSource.setSections([sectionModel])
            
            DispatchQueue.main.async {
                self.delegate?.didCompleteLoading()
            }
        }
        
        // Datasource
        dataSource.configureCell = { dataSource, cv, indexPath, item in
            let cell = cv.dequeueReusableCell(forIndexPath: indexPath) as CommentCell
            
            cell.viewModel = item
            
            return cell
        }
    }
    
}
