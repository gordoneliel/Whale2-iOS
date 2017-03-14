//
//  Answer.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/7/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import CoreData

final class Answer: NSManagedObject, ManagedObjectConfigurable {
    
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: Answer.entityName, in: context)!
        self.init(entity: entityDescription, insertInto: context)
    }
    
    func configureWithJSONAnswer(_ jsonAnswer: JSONAnswer) {
        serverId = NSNumber(integerLiteral: jsonAnswer.id)
        videoURL = jsonAnswer.videoURL.absoluteString
        thumbnailURL = jsonAnswer.thumbnailURL.absoluteString
    }
}
