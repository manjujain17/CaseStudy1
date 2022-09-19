//
//  CaseStudy1UITests.swift
//  CaseStudy1UITests
//
//  Created by adminn on 18/08/22.
//

import XCTest

class CaseStudy1UITests: XCTestCase {
    let app = XCUIApplication()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
            
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func  testLoginToSignUp() throws {
        app.launch()
        app.buttons["Sign up"].tap()
        XCTAssert(app.navigationBars["SignUp"].exists,"Signup Page doesn't exist")
        XCTAssert(app.textFields["Name"].exists)
        app.textFields["Name"].tap()
        XCTAssert(app.textFields["Email ID"].exists)
        app.textFields["Email ID"].tap()
        XCTAssert(app.textFields["Mobile"].exists)
        app.textFields["Mobile"].tap()
        XCTAssert(app.secureTextFields["Password"].exists)
        app.secureTextFields["Password"].tap()
        XCTAssert(app.secureTextFields["Confirm Password"].exists)
        app.secureTextFields["Confirm Password"].tap()
        XCTAssert(app.buttons["SignUp"].exists)
        app.buttons["SignUp"].tap()
        XCTAssertNotNil(app.alerts,"Alerts are not shown")
        app.buttons["OK"].tap()
        app.terminate()
        app.activate()
    }
    func testLoginToEmployeee() throws {
        app.launch()
        XCTAssert(app.textFields["Email ID"].exists, "Email ID TextField doesn't exist")
        app.textFields["Email ID"].tap()
        app.textFields["Email ID"].typeText("ritesh@gmail.com")
        XCTAssert(app.secureTextFields["Password"].exists, "Password Textfield doesn't exist")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("Qwerty@12")
        app.buttons["Login"].tap()
        XCTAssertNotNil(app.alerts,"Alerts not shown")
        XCTAssert(app.navigationBars["Employees"].exists, "Employees Page doesn't exist")
        app.cells.firstMatch.tap()
        XCTAssert(app.navigationBars["Hello Ritesh"].exists, "Employee row selected doesn't exist")
        app.terminate()
        app.activate()
    }
    func testLoginToForgotPassword() throws {
        app.launch()
        app.buttons["Forgot Password?"].tap()
        XCTAssert(app.navigationBars["Reset Password"].exists, "Forgot Password Page doesn't exist")
        XCTAssert(app.textFields["Email ID"].exists, "Email ID TextField doesn't exist")
        XCTAssert(app.buttons["Submit"].exists)
        app.terminate()
        app.activate()
    }
    func testLoginToNetworkCall() throws {
        app.launch()
        app.buttons["Network Call"].tap()
        XCTAssert(app.navigationBars["JSON & XML Data"].exists, "Network Call Page doesn't exist")
        XCTAssert(app.buttons["JSON Data"].exists, "JSON Button doesn't exist")
        app.buttons["JSON Data"].tap()
        app.cells.firstMatch.tap()
        XCTAssert(app.buttons["XML Data"].exists, "XML Button doesn't exist")
        app.buttons["XML Data"].tap()
        app.cells.firstMatch.tap()
        app.terminate()
        app.activate()
    }
    func testLoginToOfflineJSON() throws {
        app.launch()
        app.buttons["Offline JSON"].tap()
        XCTAssert(app.navigationBars["JSON Offline Data"].exists, "JSON Page doesn't exist")
        app.buttons["Reload JSON"].tap()
        app.cells.firstMatch.tap()
        app.terminate()
        app.activate()
    }
    func testLoginToMapView() throws {
        app.launch()
        app.buttons["Map View"].tap()
        XCTAssert(app.maps.element.exists)
        app.terminate()
    }
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
