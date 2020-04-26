//
//  OnboardingFlow.swift
//  CovidWatch iOSUITests
//
//  Created by Isaiah Becker-Mayer on 4/20/20.
//  
//
// swiftlint:disable line_length

import XCTest

class OnboardingFlow: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        #if targetEnvironment(simulator)
            // do nothing
            // we remove the app from the simulator in the scheme pre-test step with:
            // /usr/bin/xcrun simctl uninstall booted edu.stanford.covidwatch.ios
        #else
            // Delete the app if it exists, in order to reset the permissions settings.
            // (I tried other approaches besides this but none of them worked)
            Springboard.deleteApp(name: "Covid Watch") // only way to clear the app on real device
        #endif

        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    //    Test for when the user does all the right things in the onboarding flow
    //swiftlint:disable function_body_length
    func testOnboardingFlow() {
        let app = XCUIApplication()

//        Splash
        XCTAssertTrue(app.images["Title"].exists)
        XCTAssertTrue(app/*@START_MENU_TOKEN@*/.staticTexts["Description"]/*[[".staticTexts[\"splash-description\"]",".staticTexts[\"Description\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        app.buttons["Start"].tap()

//        Bluetooth
        XCTAssertTrue(app.images["Logo"].exists)
        XCTAssertFalse(app.buttons["menu"].exists)
        XCTAssertTrue(app.staticTexts["Privately Connect"].exists)
        var predicate = NSPredicate(format: "label LIKE %@", "We use Bluetooth to anonymously log interactions with other Covid Watch users. Your personal data is always private and never shared.")
        XCTAssertTrue(app.staticTexts.element(matching: predicate).exists)
        XCTAssertTrue(app.staticTexts["This is required for the app to work."].exists)
        app/*@START_MENU_TOKEN@*/.staticTexts["button-text"]/*[[".staticTexts[\"Allow Bluetooth\"]",".staticTexts[\"button-text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        var bluetoothAllowed = true
        #if targetEnvironment(simulator)
            // no bluetooth permissions on simulator, do nothing
        #else
            bluetoothAllowed = false
            addUIInterruptionMonitor(withDescription: "“Covid Watch” Would Like to Use Bluetooth") { (alert) -> Bool in
                alert.scrollViews.otherElements.buttons["OK"].tap()
                bluetoothAllowed = true
                return true
            }
            wait {
                app.tap() // needed to trigger addUIInterruptionMonitor
            }
        #endif

        waitAndCheck { bluetoothAllowed }
        
//        Notifications
        XCTAssertTrue(app.images["Logo"].exists)
        XCTAssertFalse(app.buttons["menu"].exists)
        XCTAssertTrue(app.staticTexts["Receive Alerts"].exists)
        predicate = NSPredicate(format: "label LIKE %@", "Enable notifications to receive anonymized alerts when you have come into contact with a confirmed case of COVID-19.")
        XCTAssertTrue(app.staticTexts.element(matching: predicate).exists)
        var alertPressed = false
        addUIInterruptionMonitor(withDescription: "“Covid Watch” Would Like to Send You Notifications") { (alert) -> Bool in
            alert.scrollViews.otherElements.buttons["Allow"].tap()
            alertPressed = true
            return true
        }
        app/*@START_MENU_TOKEN@*/.staticTexts["button-text"]/*[[".staticTexts[\"Allow Notifications\"]",".staticTexts[\"button-text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        wait {
            app.tap() // needed to trigger addUIInterruptionMonitor
        }
        waitAndCheck { alertPressed }

//        Home
        XCTAssertTrue(app.images["Logo"].exists)
        XCTAssertTrue(app.buttons["menu"].exists)
        let contentTextViewsQuery = app.textViews.matching(identifier: "content")
        XCTAssertTrue(contentTextViewsQuery.staticTexts["You're all set!"].exists)
        XCTAssertTrue(contentTextViewsQuery.staticTexts["Thank you for helping protect your communities. You will be notified of potential contact with COVID-19."].exists)
        let subTextTextViewsQuery = app.textViews.matching(identifier: "sub-text")
        XCTAssertTrue(subTextTextViewsQuery.staticTexts["It works best when everyone uses it."].exists)
        XCTAssertTrue(subTextTextViewsQuery.staticTexts["Share your result anonymously to help keep your community stay safe."].exists)
    }

}

extension XCTestCase {
    func waitAndCheck(_ description: String = "", _ timeout: Double = 0.5, callback: () -> Bool) {
        let exp = self.expectation(description: description)
        let result = XCTWaiter.wait(for: [exp], timeout: timeout)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(callback())
        } else {
            XCTFail("Timout wating \(timeout) for \(description)")
        }
    }
    func wait(_ description: String = "", _ timeout: Double = 0.5, callback: () -> Void) {
        let exp = self.expectation(description: description)
        let result = XCTWaiter.wait(for: [exp], timeout: timeout)
        if result == XCTWaiter.Result.timedOut {
            callback()
        } else {
            XCTFail("Timout wating \(timeout) for \(description)")
        }
    }
}
