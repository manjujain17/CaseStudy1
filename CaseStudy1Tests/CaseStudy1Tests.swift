//
//  CaseStudy1Tests.swift
//  CaseStudy1Tests
//
//  Created by adminn on 18/08/22.
//

import XCTest
@testable import CaseStudy1

class CaseStudy1Tests: XCTestCase {
    var loginVC: LoginViewController!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginVC = LoginViewController.getVC()
        
        loginVC!.loadViewIfNeeded()
    }
    func test_loginVC_validEmail() throws {
        XCTAssertTrue(loginVC.checkEmail(emailText: "ritesh@gmail.com"), "Email iD is not present in core data")
        
    }
    
    func test_loginVC_emailOutlet() throws {
        XCTAssertNotNil(loginVC.emailID,"Email id outlet not present")
    }
    func test_loginVC_loginButton() throws {
        let logButton: UIButton = try XCTUnwrap(loginVC.loginButton,"Login Button has no reference outlet")
        let loginAction = try XCTUnwrap(logButton.actions(forTarget: loginVC, forControlEvent: .touchUpInside))
        XCTAssertEqual(loginAction.count, 1)
        XCTAssertEqual(loginAction.first, "loginActionButton:", "There is no action given to this button")
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
