//
//  User.swift
//  BlakeApp
//
//  Created by suitecontrol on 29/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import UIKit

struct User: Decodable, Equatable {
    let username: String
    let user_id: String
    let type: String
    let auth_token: String
    let student_ids: [String]?
    let parent_id: String?
}
