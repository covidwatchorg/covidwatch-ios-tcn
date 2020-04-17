//
//  Created by Zsombor Szabo on 11/03/2020.
//
//

import XCTest

class Test01: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testSplashPage() {
        let logo = app/*@START_MENU_TOKEN@*/.images["logo-cw-white"]/*[[".images[\"logo\"]",".images[\"logo-cw-white\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let title = app/*@START_MENU_TOKEN@*/.staticTexts["Title"]/*[[".staticTexts[\"covidwatch\"]",".staticTexts[\"Title\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let superheroImage = app/*@START_MENU_TOKEN@*/.images["family-superhero"]/*[[".images[\"superhero\"]",".images[\"family-superhero\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let description = app/*@START_MENU_TOKEN@*/.staticTexts["Description"]/*[[".staticTexts[\"splash-description\"]",".staticTexts[\"Description\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let start = app.buttons["Start"]

        XCTAssertTrue(logo.exists)
        XCTAssertTrue(title.exists)
        XCTAssertTrue(superheroImage.exists)
        XCTAssertTrue(description.exists)
        XCTAssertTrue(start.exists)
    }
}
