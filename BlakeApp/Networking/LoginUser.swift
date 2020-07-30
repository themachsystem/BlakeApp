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
    var request: URLRequest?
    
    init(baseURL: URL,
         session: URLSession,
         request: URLRequest?) {
        self.baseURL = baseURL
        self.session = session
        self.request = request
    }
    
    func login(username: String, password: String, completion: @escaping (User?, Error?) -> Void) -> URLSessionDataTask {
        let url = URL(string: "login", relativeTo: baseURL)!
        let paramDict = ["username":username,"password":password]
        if request != nil {
            request!.httpMethod = "POST"
            do {
                request!.httpBody = try JSONSerialization.data(withJSONObject: paramDict, options: .prettyPrinted)
            } catch {
                completion(nil, error)
            }
        }
        let dataTask = session.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil,
                let data = data else {
                    completion(nil, error)
                    return
            }
            let decoder = JSONDecoder()
            let user = try! decoder.decode(User.self, from: data)
            completion(user, error)
        }
        dataTask.resume()
        return dataTask
    }
}
