//
//  ProfileSectionModel.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/12/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//

import Foundation
import UIKit

struct ProfileSectionModel {
    var header: String
    var items: [Item]
}

extension ProfileSectionModel: SectionModelType {
    typealias Item = UserProfileCellViewModel

    init(original: ProfileSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}


