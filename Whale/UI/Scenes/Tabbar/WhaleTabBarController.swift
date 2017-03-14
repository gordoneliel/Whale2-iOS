//
//  WhaleTabBarController.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/11/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

class WhaleTabBarController: UITabBarController {

    let tabBarViewModel = TabBarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers = tabBarViewModel
            .scenes
            .map{$0.viewController()}
    }
}

extension WhaleTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
}
