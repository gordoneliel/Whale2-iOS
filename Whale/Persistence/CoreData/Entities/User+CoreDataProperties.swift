//
//  User+CoreDataProperties.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/14/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import CoreData

extension User {
    @NSManaged var serverId: Int64
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var email: String
    @NSManaged var followerCount: Int64
    @NSManaged var followingCount: Int64
    @NSManaged var profileImageURL: String?
    @NSManaged var updatedAt: Date
}
