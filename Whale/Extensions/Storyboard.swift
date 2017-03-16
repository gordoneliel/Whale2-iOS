//
//  Storyboard.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/11/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import UIKit

enum Scene: Int {
    case home
    case search
    case activity
    case profile
}

extension Scene {
    func viewController() -> UIViewController {
        var vc = UIViewController()
        
        switch self {
        case .home:
            vc = instantiate(HomeViewController.self)
        case .search:
            vc = instantiate(SearchViewController.self)
        case .activity:
            vc = instantiate(ActivityViewController.self)
        case .profile:
            vc = instantiate(ProfileViewController.self)
        }
        
        let tabItem = UITabBarItem(
            title: self.description,
            image: self.icon(),
            tag: self.rawValue
        )
        
        tabItem.selectedImage = self.selectedIcon()
            
        vc.tabBarItem = tabItem
        return vc
    }
    
    func icon() -> UIImage {
        switch self {
        case .home,
             .activity,
             .search,
             .profile:
            return UIImage(named: self.description.lowercased())!
        }
    }
    
    func selectedIcon() -> UIImage {
        switch self {
        case .home,
             .activity,
             .search,
             .profile:
            return UIImage(named: self.description.lowercased() + "Selected")!
        }
    }
}

extension Scene: CustomStringConvertible {
    var description: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .activity:
            return "Activity"
        case .profile:
            return "Profile"
        }
    }
}

extension Scene {
    public func instantiate<T: UIViewController>(_ viewController: T.Type,
                            inBundle bundle: Bundle = .main) -> T {
        guard let vc = UIStoryboard(name: self.description, bundle: nil)
                .instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T
            else { fatalError("Couldn't instantiate \(T.storyboardIdentifier) from \(self.rawValue)") }
        return vc
    }
}
