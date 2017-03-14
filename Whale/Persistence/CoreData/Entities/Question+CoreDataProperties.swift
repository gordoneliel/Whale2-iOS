//
//  Question+CoreDataProperties.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/7/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import CoreData

extension Question {
    @NSManaged var serverId: NSNumber?
    @NSManaged var content: String
}
