//
//  HomeVieModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/9/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Gloss
import UIKit

class HomeViewModel: ViewModelType {
    let dataSource = SectionedDataSource<HomeSectionModel>()
    private let networking = BaseNetworking.newNetworking()
    weak var delegate: ViewModelDidComplete?
    var selectedItem: AnswerCellViewModel?
    var answers: [AnswerCellViewModel] = []
    let title = "Answers"
    
    private var pagination: PaginationViewModel<JSONAnswer>
    private var paginationState: PaginationState = .loading(page: 0, pageSize: 3)
    
    init() {
        pagination = PaginationViewModel<JSONAnswer>()
        
        // DataSource
        dataSource.configureCell = { (dataSource, cv, indexPath, cellItem) in
            
            switch dataSource.sectionModels[indexPath.section] {
                
            case let .answers(_, items):
                let answerCell = cv.dequeueReusableCell(forIndexPath: indexPath) as AnswerCell
                
                answerCell.answerCellViewModel = items[indexPath.row]
                
                return answerCell
            }
        }
        
        dataSource.supplementaryViewFactory = { dataSource, cv, kind, indexPath in
            let section = dataSource.sectionModels[indexPath.section]
            
            switch (section, kind) {
            case (.answers, UICollectionElementKindSectionHeader):
                let header = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, forIndexPath: indexPath) as GenericHeaderCell
                
                header.headerLabel.text = "Latest Answers"
                return header
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func loadNextPage() {
        // From nextIdle to loading
        let pageState = paginationState.next()
        
        let newRequest = CoreApiClient.answers(
            page: pageState.paginationValue().page,
            pageSize: pageState.paginationValue().pageSize
        )
        
        pagination
            .paginate(request: newRequest) { [unowned
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
            
            guard let answers = self.pagination.pageData?.data else {return}
            
            guard !answers.isEmpty else {return}
            
            let items = answers.map { answer in
                return AnswerCellViewModel(
                    question: answer.question.content,
                    videoURL: answer.videoURL,
                    thumbnailURL: answer.thumbnailURL,
                    questionUserName: "\(answer.question.sender.firstName) \(answer.question.sender.lastName)",
                    answerUserName: "\(answer.question.receiver.firstName) \(answer.question.receiver.lastName)",
                    questionUserImageURL: answer.question.sender.profileImageUrl,
                    answerUserImageURL: answer.question.receiver.profileImageUrl,
                    answerId: answer.id,
                    likeCount: "\(answer.likesCount)",
                    commentCount: "\(answer.commentsCount)"
                )
            }
            
            self.answers = items
            
            guard let existing = self.dataSource.sectionModels.first else {
                let section = HomeSectionModel.answers(title: "Answers", items: items)
                self.dataSource.setSections([section])
                return
            }
            
            let newCollection = existing.items + items
            
            let newSection = HomeSectionModel.answers(title: "Answers", items: newCollection)
            
            self.dataSource.setSections([newSection])
        }
    }
    
    func canLoadNext() -> Bool {
        return paginationState == PaginationState.nextIdle(page: 0, pageSize: 0)
    }
}


