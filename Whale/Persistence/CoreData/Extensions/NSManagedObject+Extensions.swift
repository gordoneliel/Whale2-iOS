//
//  NSManagedObject+Extensions.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/7/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import CoreData

protocol ManagedObjectType {
    static var entityName: String {get}
}

extension ManagedObjectType {
    static var entityName: String {
        return String(describing: self)
    }
}

extension NSManagedObject: ManagedObjectType {}

extension NSManagedObjectContext {
    func insertObject<A: NSManagedObject>() -> A where A: ManagedObjectType {
        guard let obj = NSEntityDescription
            .insertNewObject(forEntityName: A.entityName,
                             into: self) as? A else {
                                                fatalError("Entity \(A.entityName) does not correspond to \(A.self)")
        }
        return obj
    }
}

protocol ManagedObjectConfigurable {
    init(context: NSManagedObjectContext)
}
