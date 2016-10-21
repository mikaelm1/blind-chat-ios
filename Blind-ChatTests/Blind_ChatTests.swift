//
//  Blind_ChatTests.swift
//  Blind-ChatTests
//
//  Created by Mikael Mukhsikaroyan on 10/20/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import XCTest
@testable import Blind_Chat

class Blind_ChatTests: XCTestCase {
    
    let apiManager = APIManager.shared
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserRegistration() {
        // The username and email would need to be changing everytime this test is run, unless can figure out how to send it to some test db
        /*
        let user = User(username: "test2", email: "test2@example.com")
        let exp = self.expectation(description: "Expecting to register")
        apiManager.registerUser(user: user, withPassword: "test") { (error) in
            if error != nil {
                XCTFail()
            } else {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
        */
    }
    
    func testUserLogin() {
        let exp = expectation(description: "Expecting to login")
        apiManager.loginUser(username: "test", password: "test") { (error) in
            if error != nil {
                XCTFail()
            } else {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
