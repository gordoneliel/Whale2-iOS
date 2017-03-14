//
//  UIViewController+Extensions.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/11/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public static var storyboardIdentifier: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}
