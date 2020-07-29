//
//  BlakeAppTests.swift
//  BlakeAppTests
//
//  Created by suitecontrol on 29/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import XCTest
@testable import BlakeApp

class BlakeAppTests: XCTestCase {
    var sut: LoginUser!
    
    var baseURL: URL!
    var mockSession: MockURLSession!
    
    override func setUpWithError() throws {
        baseURL = URL(string: "https://blake.com.au/api")!
        mockSession = MockURLSession()
        sut = LoginUser(baseURL: baseURL, session: mockSession)
    }

    override func tearDownWithError() throws {
        baseURL = nil
        mockSession = nil
        sut = nil
    }

    func test_init_sets_baseURL() {
        XCTAssertEqual(sut.baseURL, sut.baseURL)
    }
    
    func test_init_sets_session() {
        XCTAssertEqual(sut.session, mockSession)
    }
    
    func test_login_callsExpectedURL() {
        // given
        let loginURL = URL(string: "login", relativeTo: baseURL)
        
        // when
        let mockTask = sut.login(username: "", password: "", completion: {  _, _  in
            
        })  as! MockURLSessionDataTask
        
        // then
        XCTAssertEqual(mockTask.url, loginURL)
    }
}

class MockURLSession: URLSession {
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask(completionHandler: completionHandler, url: url)
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: (Data?, URLResponse?, Error?) -> Void
    var url: URL
    
    init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void, url: URL) {
        self.completionHandler = completionHandler
        self.url = url
        super.init()
    }
    
    override func resume() {
        
    }
}
