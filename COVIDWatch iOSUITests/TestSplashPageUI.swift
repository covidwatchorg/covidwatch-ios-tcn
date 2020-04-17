//
//  Created by Zsombor Szabo on 11/03/2020.
//
//

import XCTest

class TestSplashPageUI: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation
        // required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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

//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
    
}
