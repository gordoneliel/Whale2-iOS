//
//  AppDelegateViewModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/23/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import UIKit

enum AuthStatus {
    case loggedIn
    case unauthorized
}

struct AppDelegateViewModel {
    var rootView: UIViewController!
    
    var authStatus: AuthStatus
    var keys = AppKeys.instance
    
    init() {
        self.authStatus = keys.hasToken == true ? AuthStatus.loggedIn : AuthStatus.unauthorized
        
        self.rootView = getRootView(authStatus: self.authStatus)
        
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
    func getRootView(authStatus: AuthStatus) -> UIViewController {
        switch authStatus {
        case .loggedIn:
            return WhaleTabBarController()
        case .unauthorized:
            return LoginViewController(authStatus: authStatus, nibName: LoginViewController.storyboardIdentifier, bundle: nil)
        }
    }
}
