//
//  UserViewModel.swift
//  BlakeApp
//
//  Created by suitecontrol on 30/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import Foundation

enum UserType: String {
    case parent
    case student
    case unknown
}

class UserViewModel {
    let user: User
    let username: String
    let user_id: String
    let type: UserType
    let auth_token: String
    
    init(user: User) {
        self.user = user
        self.username = user.username
        self.user_id = user.user_id
        self.type = UserType(rawValue: user.type) ?? .unknown
        self.auth_token = user.auth_token
    }
}

class ParentViewModel: UserViewModel {
    let studentIDs: [String]
    override init(user: User) {
        self.studentIDs = user.student_ids!
        super.init(user: user)
    }
}

class StudentViewModel: UserViewModel {
    let parentID: String
    override init(user: User) {
        self.parentID = user.parent_id!
        super.init(user: user)
    }
}
