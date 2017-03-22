//
//  ActivityViewModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/15/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import Result
import Moya
import UIKit

class ActivityViewModel {
    let dataSource = SectionedDataSource<ActivitySectionModel>()
    weak var delegate: ViewModelDidComplete?
    weak var activityViewController: ActivityViewController?
    
    init() {
        
        let networking = BaseNetworking.newNetworking()
        
        // Pending Questions Section
        networking.request(CoreApiClient.questions) { result in
            
            switch result {
            case let .success(response):
                do {
                    let pageData = try response.mapTo(PageData<JSONQuestion>.self)
                    let models = pageData.data

                    let questions = models.map {
                        return SectionItem.MyQuestionItem(
                            question: $0.content,
                            user: "\($0.sender.firstName) \($0.sender.lastName)",
                            image: $0.sender.profileImageUrl
                        )
                    }
                    
                    let sectionModel = ActivitySectionModel.question(title: "Pending Questions", items: questions)
                    
                    if self.dataSource.sectionModels.isEmpty {
                        self.dataSource.setSections([sectionModel])
                    }else {

                        let oldSections = self.dataSource.sectionModels.filter {$0.header == sectionModel.header}.first ?? sectionModel
                        
                        let newSection = ActivitySectionModel(original: oldSections, items: sectionModel.items)
                        self.dataSource.setSections([newSection])
                    }
                    
                    DispatchQueue.main.async {
                        self.delegate?.didCompleteLoading()
                    }
                    
                }catch {
                    
                }
            case .failure:
                break
            }
        }
        
        // New Followers Section
        let followItem = SectionItem.FollowCellItem(userName: "Eliel, G")
        let newFollowersSection = ActivitySectionModel.follow(title: "New Followers", items: [followItem])
        
        if self.dataSource.sectionModels.isEmpty {
            self.dataSource.setSections([newFollowersSection])
        }else {
            let oldSections = self.dataSource.sectionModels.first ?? newFollowersSection
            let newSection = ActivitySectionModel.init(original: oldSections, items: oldSections.items)
            self.dataSource.setSections([newSection])
        }
        
        // Datasource
        dataSource.configureCell = { dataSource, cv, indexPath, item in
            switch dataSource.sectionModels[indexPath.section] {
            case let .follow(_, items):
                let item = items[indexPath.row]
                let cell = cv.dequeueReusableCell(forIndexPath: indexPath) as ActivityFollowCell
                cell.viewModel = item

                return cell
            case let.question(_, items):
                let item = items[indexPath.row]
                let cell = cv.dequeueReusableCell(forIndexPath: indexPath) as ActivityQuestionCell
                cell.viewModel = item
                cell.delegate = self.activityViewController
                
                return cell
            }
        }
        
        dataSource.supplementaryViewFactory = { dataSource, cv, kind, indexPath in
            
            let header = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, forIndexPath: indexPath) as GenericHeaderCell
            
            header.headerLabel.text = dataSource.sectionModels[indexPath.section].header
            return header
        }
    }
}
