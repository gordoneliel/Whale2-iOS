//
//  TabBarViewModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/11/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

struct TabBarViewModel {
    let scenes: [Scene]
    
    init() {
        scenes = [.home, .search, .activity, .profile]
    }
}
