//
//  UserProfileCellViewModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/12/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation

struct UserProfileCellViewModel {
    let name: String
    let email: String
    let followCount: String
    let imageURL: URL?
    let personal: Bool = true
}
