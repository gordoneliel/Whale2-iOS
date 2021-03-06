//
//  WhaleSynchronizer.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/8/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import CoreData
import Gloss

class WhaleSynchronizer {
    let whaleAPIClient: CoreApiClient
    let networking: BaseNetworking
    let downloadQueue = OperationQueue()
    let coreDataClient = CoreDataClient(stack: CoreDataStack())
    
    
    init(networking: BaseNetworking = BaseNetworking.newNetworking(), apiClient: CoreApiClient) {
        self.whaleAPIClient = apiClient
        self.networking = networking
        downloadQueue.maxConcurrentOperationCount = 1
    }
    
    func sync(_ completionBlock: @escaping () -> Void) -> Void {
        
        // User Sync
        downloadSync(entity: User.self, jsonModel: JSONUser.self) {
            completion in
            
            let jsonUser = completion.1
            
            // Create new user if none exists
            guard var user = completion.0.first
                else {
                    let newUser = User(context: self.coreDataClient.viewContext)
                    newUser.configureWithJSONUser(jsonUser)
                    self.coreDataClient.saveStack()
                    return completionBlock()
            }
            
            // Check updated up timestamp and update local model
            guard jsonUser.updatedAt >= user.updatedAt else {
                return completionBlock()
            }
            
            // Else update local model
            let newUser = User(context: self.coreDataClient.viewContext)
            newUser.configureWithJSONUser(jsonUser)
            
            user = newUser
            // Save changes
            self.coreDataClient.saveStack()
            completionBlock()
        }
    }
    
    private func downloadSync<T: NSManagedObject, U: Gloss.Decodable>(entity: T.Type, jsonModel: U.Type, _ completionBlock: @escaping (_ entity: [T], _ jsonModel: U) -> Void) -> Void {
        
        // Download model
        let downloadOperation = BlockOperation()
        
        downloadOperation.addExecutionBlock {
            self.networking.request(self.whaleAPIClient) { completion in
                switch completion {
                case let .success(response):
                    do {
                        let jsonModel = try response.mapTo(U.self)
                        
                        let one = self.coreDataClient.all(model: T.self)
                        
                        completionBlock(one, jsonModel)
                    }catch {
                        
                    }
                    
                case .failure(_):
                    break
                }
            }
        }
        
        // Add to queue
        downloadQueue.addOperation(downloadOperation)
    }
}
