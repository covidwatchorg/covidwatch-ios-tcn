//
//  TestNotificationPageUI.swift
//  COVIDWatch iOSUITests
//
//  Created by Nikhil Kumar on 4/18/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import XCTest

class Test03: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("XCTest")
        app.launchEnvironment["isFirstTimeUser"] = "true"
        app.launch()
    }

    override func tearDown() {
        app.terminate()
        super.tearDown()
    }

    func testNotificationPage() {
        app/*@START_MENU_TOKEN@*/.staticTexts["button-text"]/*[[".staticTexts[\"Allow Bluetooth\"]",".staticTexts[\"button-text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let title = app.textViews["large-text"]
        let description = app.textViews["main-text"]
        let button = app/*@START_MENU_TOKEN@*/.staticTexts["button-text"]/*[[".staticTexts[\"Allow Notifications\"]",".staticTexts[\"button-text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        XCTAssertTrue(title.exists)
        XCTAssertTrue(description.exists)
        XCTAssertTrue(button.exists)
    }

    func testNotificationPermissions() {
        app/*@START_MENU_TOKEN@*/.staticTexts["button-text"]/*[[".staticTexts[\"Allow Bluetooth\"]",".staticTexts[\"button-text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["button-text"]/*[[".staticTexts[\"Allow Bluetooth\"]",".staticTexts[\"button-text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
            let alertButton = alert.buttons["Allow"]
            
            XCTAssertTrue(alertButton.exists)
            alertButton.tap()
            return true
        }
        app.tap()
    }

}
