//
//  CoreDataClient.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/7/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import CoreData

class CoreDataClient {
    let stack: CoreDataStack
    let viewContext: NSManagedObjectContext
    
    init(stack: CoreDataStack) {
        self.stack = stack
        self.viewContext = stack.viewContext
    }
    
    func one<T: NSManagedObject>(model: T.Type) -> T? {
        do {
            let request = NSFetchRequest<T>(entityName: model.entityName)
            return try viewContext.fetch(request).first
        }catch {
            return nil
        }
    }
    
    func all<T: NSManagedObject>(model: T.Type) -> [T] {
        do {
            let request = NSFetchRequest<T>(entityName: model.entityName)
            return try viewContext.fetch(request)
        }catch {
            return []
        }
    }
    
    func saveStack() {
        stack.save()
    }
}
