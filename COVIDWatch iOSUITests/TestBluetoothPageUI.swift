//
//  dummyName.swift
//  COVIDWatch iOSUITests
//
//  Created by Hayden Riddiford on 4/16/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import XCTest

class TestBluetoothPageUI: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBluetoothPage() throws {
        
        // Navigate to Bluetooth Page
        XCUIApplication().buttons[AccessibilityLabel.startButton].tap()
        
        let app = XCUIApplication()
        let textViewsQuery = app.textViews
        XCTAssertEqual(textViewsQuery.staticTexts[AccessibilityIdentifier.LargeText.rawValue].label, "Privately Connect")
        XCTAssertEqual(textViewsQuery.staticTexts[AccessibilityIdentifier.MainText.rawValue].label,
                       "We use Bluetooth to anonymously log interactions with other Covid Watch users. Your personal data is always private and never shared.")

        //app.staticTexts["Allow Bluetooth"].tap()
        
        
    }

}
