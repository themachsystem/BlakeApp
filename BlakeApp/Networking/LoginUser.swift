//
//  LoginUser.swift
//  BlakeApp
//
//  Created by suitecontrol on 29/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import Foundation

class LoginUser {
    let baseURL: URL
    let session: URLSession
    
    init(baseURL: URL, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func login(username: String, password: String, completion: @escaping (User?, Error?) -> Void) -> URLSessionDataTask {
        let url = URL(string: "login", relativeTo: baseURL)!
        return session.dataTask(with: url) { _, _, _ in
            
        }
    }
}
