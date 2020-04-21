//
//  Created by Zsombor Szabo on 11/03/2020.
//
//

import XCTest

class Test01: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        app = XCUIApplication()
        app.launchEnvironment["isFirstTimeUser"] = "true"
        app.launchEnvironment["isSplashTest"] = "true"
        app.launch()
    }

    override func tearDown() {
        app.terminate()
        super.tearDown()
    }

    func testSplashPage() {
        let logo = app.images["logo-cw-white"]
        let title = app.staticTexts["Title"]
        let superheroImage = app.images["family-superhero"]
        let description = app.staticTexts["Description"]
        let start = app.buttons["Start"]
        
        XCTAssertTrue(logo.exists)
        XCTAssertTrue(title.exists)
        XCTAssertTrue(superheroImage.exists)
        XCTAssertTrue(description.exists)
        XCTAssertTrue(start.exists)
    }
}
