//
//  HomeVieModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/9/17.
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

class HomeViewModel: ViewModelType {
    let dataSource = SectionedDataSource<HomeSectionModel>()
    let networking = BaseNetworking.newNetworking()
    weak var delegate: ViewModelDidComplete?
    var selectedItem: AnswerCellViewModel?
    var answers: [AnswerCellViewModel] = []
    
    let title = "Answers"
    
    let downloadQueue = OperationQueue()
    var paginationState: PaginationState = .loading(page: 0, pageSize: 3)
    
    init() {
        // Our download queue is a synchronous one,
        // that allows us to wait for a page to
        // complete downloading before kicking off another request
        // when scrolled to bottom or top
        downloadQueue.qualityOfService = .userInitiated
        downloadQueue.maxConcurrentOperationCount = 1
        
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
                
                header.headerLabel.text = "Answers"
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
        
        let downloadOp = DownloadOperation<JSONAnswer>(
            page: pageState.paginationValue().page,
            pageSize: pageState.paginationValue().pageSize,
            apiClient: newRequest
        )
        
        downloadQueue.addOperation(downloadOp)
        
        downloadOp.completionBlock = { [weak self] in
            defer {
                DispatchQueue.main.async {
                    self?.delegate?.didCompleteLoading()
                    self?.paginationState = .nextIdle(
                        page: downloadOp.currentPage,
                        pageSize: downloadOp.pageSize
                    )
                    if downloadOp.isFinalPage {
                        self?.paginationState = .loadedAllPages
                    }
                }
            }
            
            guard let answers = downloadOp.pageData?.data else {return}
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
                    answerId: answer.id
                )
            }
            
            self?.answers = items
            guard let existing = self?.dataSource.sectionModels.first else {
                let section = HomeSectionModel.answers(title: "Answers", items: items)
                self?.dataSource.setSections([section])
                return
            }
            
            let newCollection = existing.items + items
            
            let newSection = HomeSectionModel.answers(title: "Answers", items: newCollection)
            
            self?.dataSource.setSections([newSection])
        }
    }
    
    func canLoadNext() -> Bool {
        return paginationState == PaginationState.nextIdle(page: 0, pageSize: 0)
    }
}


