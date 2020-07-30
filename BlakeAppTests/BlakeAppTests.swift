//
//  BlakeAppTests.swift
//  BlakeAppTests
//
//  Created by suitecontrol on 29/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import XCTest
@testable import BlakeApp

struct LoginDetails {
    var username: String
    var password: String
}

class BlakeAppTests: XCTestCase {
    var sut: LoginUser!
    
    var baseURL: URL!
    var request: URLRequest!
    var mockSession: MockURLSession!
    var loginURL: URL {
        return URL(string: "login", relativeTo: baseURL)!
    }
    
    var parentLoginDetails: LoginDetails!
    var studentLoginDetails: LoginDetails!

    override func setUpWithError() throws {
        baseURL = URL(string: "https://blake.com.au/api")!
        mockSession = MockURLSession()
        request = URLRequest(url: loginURL)
        sut = LoginUser(baseURL: baseURL,
                        session: mockSession,
                        request: request)
        parentLoginDetails = LoginDetails(username: "example-parent", password: "1234")
        studentLoginDetails = LoginDetails(username: "example-child", password: "5678")

    }
    
    override func tearDownWithError() throws {
        baseURL = nil
        mockSession = nil
        request = nil
        sut = nil
    }
    
    func whenLoginUser(username: String = "",
                       password: String = "",
                       data: Data? = nil,
                       statusCode: Int = 200,
                       error: Error? = nil) ->
        (calledCompletion: Bool, user: User?, error: Error?) {
            var calledCompletion = false
            var receivedUser: User? = nil
            var receivedError: Error? = nil
            
            let response = HTTPURLResponse(url: loginURL,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            
            // when
            let mockTask = sut.login(username: username, password: password) {[weak self] user, error in
                calledCompletion = true
                receivedError = error
                guard let self = self else {
                    return
                }
                guard username == self.parentLoginDetails.username && password == self.parentLoginDetails.password else {
                    return
                }
                receivedUser = user
                } as! MockURLSessionDataTask
            mockTask.completionHandler(data, response, error)
            return (calledCompletion, receivedUser, receivedError)
    }
    
    func test_init_sets_baseURL() {
        XCTAssertEqual(sut.baseURL, baseURL)
    }
    
    func test_init_sets_session() {
        XCTAssertEqual(sut.session, mockSession)
    }
    
    func test_login_callsExpectedURL() {
        // when
        let mockTask = sut.login(username: "", password: "") { user, error in
            
            }  as! MockURLSessionDataTask
        
        // then
        XCTAssertEqual(mockTask.url, loginURL)
    }
    
    func test_login_callsResumeTask() {
        // when
        let mockTask = sut.login(username: "", password: "") { user, error in
            
            } as! MockURLSessionDataTask
        
        // then
        XCTAssertTrue(mockTask.calledResume)
    }
    
    func test_login_givenResponseStatusCode404_callsCompletion() {
        // when
        let result = whenLoginUser(statusCode: 404)
        
        // then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.user)
        XCTAssertNil(result.error)
    }
    
    func test_login_givenError_callsCompletionWithError() throws {
        // given
        let expectedError = NSError(domain: "com.BlakeAppTests",
                                    code: 1)
        // when
        let result = whenLoginUser(error: expectedError)
        
        // then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.user)
        let actualError = try XCTUnwrap(result.error as NSError?)
        XCTAssertEqual(actualError, expectedError)
    }
    
    func test_login_verifiesUsernamePassword() throws {
        // given
        let data = try Data.fromJSON(fileName: "LoginParentResponse")
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: data)
                
        // when
        let result = whenLoginUser(username: parentLoginDetails.username, password: parentLoginDetails.password, data: data)
        
        // then
        XCTAssertTrue(result.calledCompletion)
        XCTAssertEqual(result.user, user)
        XCTAssertNil(result.error)
    }
    
    func test_init_sets_urlRequest() {
        XCTAssertEqual(sut.request, request)
    }
    
    func test_login_givenUsernamePassword_httpPOST() throws {
        // when
        whenLoginUser(username: parentLoginDetails.username, password: parentLoginDetails.password)
        
        // then
        XCTAssertEqual(sut.request?.httpMethod, "POST")
    }
    
    func test_login_givenUsernamePassword_httpBody() throws {
        // given
        let paramDictionary = ["username":parentLoginDetails.username,"password":parentLoginDetails.password]
        let bodyData = try JSONSerialization.data(withJSONObject: paramDictionary, options: .prettyPrinted)
        
        // when
        whenLoginUser(username: parentLoginDetails.username, password: parentLoginDetails.password)
        let httpBody = try XCTUnwrap(sut.request?.httpBody as Data?)
        let receivedParamDict = try JSONSerialization.jsonObject(with: httpBody, options: .allowFragments) as? [String:String]
        
        // then
        XCTAssertEqual(receivedParamDict!["username"], paramDictionary["username"])
        XCTAssertEqual(receivedParamDict!["password"], paramDictionary["password"])
    }

    func test_login_givenUsernamePassword_callsCompletionWithUser() throws {
        // given
        let data = try Data.fromJSON(fileName: "LoginParentResponse")
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: data)
        
        let paramDictionary = ["username":parentLoginDetails.username,"password":parentLoginDetails.password]
        let bodyData = try JSONSerialization.data(withJSONObject: paramDictionary, options: .prettyPrinted)

        // when
        let result = whenLoginUser(username: parentLoginDetails.username, password: parentLoginDetails.password, data: data)
        
        // then
        XCTAssertEqual(sut.request?.httpMethod, "POST")
        XCTAssertEqual(sut.request?.httpBody, bodyData)
        XCTAssertTrue(result.calledCompletion)
        XCTAssertEqual(result.user, user)
        XCTAssertNil(result.error)
    }
    
    func test_loginAsParent_callsCompletionWithParent() throws {
        // given
        let data = try Data.fromJSON(fileName: "LoginParentResponse")
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: data)
        
        // when
        let result = whenLoginUser(username: parentLoginDetails.username, password: parentLoginDetails.password, data: data)
        
        // then
        XCTAssertEqual(result.user?.type, UserType.parent.rawValue)
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
    
    /**
     * For testing only. This will update to True when resume() is called
     */
    var calledResume = false
    override func resume() {
        calledResume = true
    }
}
