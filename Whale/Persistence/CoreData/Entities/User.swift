//
//  User.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/14/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import CoreData

final class User: NSManagedObject, ManagedObjectConfigurable {
    
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: User.entityName, in: context)!
        self.init(entity: entityDescription, insertInto: context)
    }
    
    func configureWithJSONUser(_ jsonUser: JSONUser) {
        serverId = Int64(jsonUser.id)
        firstName = jsonUser.firstName
        lastName  = jsonUser.lastName
        email = jsonUser.email
        followerCount = Int64(jsonUser.followerCount ?? 0)
        followingCount = Int64(jsonUser.followingCount ?? 0)
        updatedAt = jsonUser.updatedAt
        profileImageURL = jsonUser.profileImageUrl?.absoluteString
    }

}
