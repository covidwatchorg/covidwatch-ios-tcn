//
//  dummyName.swift
//  COVIDWatch iOSUITests
//
//  Created by Hayden Riddiford on 4/16/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import XCTest

class Test02: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("XCTest")
        app.launchEnvironment["isFirstTimeUser"] = "true"
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testBluetoothPage() {
        app.buttons["Start"].tap()

        let btConnectTitle = app.textViews["large-text"]
        let btDescription = app.textViews["main-text"]
        let btButtonSubtext = app.textViews["sub-text"]
        let btButton = app/*@START_MENU_TOKEN@*/.otherElements["allow-button"]/*[[".otherElements[\"Allow Bluetooth\"]",".otherElements[\"allow-button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        XCTAssertTrue(btConnectTitle.exists)
        XCTAssertTrue(btDescription.exists)
        XCTAssertTrue(btButton.exists)
        XCTAssertTrue(btButtonSubtext.exists)
    }

}
