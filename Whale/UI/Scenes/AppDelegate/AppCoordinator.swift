//
//  AppCoordinator.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/23/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation

class AppCoordinator: NSObject {
    var authStatus = AuthStatus.unauthorized
    
    override init() {
        super.init()
    }
}
