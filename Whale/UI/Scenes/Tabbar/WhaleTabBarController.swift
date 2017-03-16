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
        
        self.tabBar.tintColor = UIColor(red: 0/255, green: 167/255, blue: 255/255, alpha: 1)
    }
}

extension WhaleTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
}
