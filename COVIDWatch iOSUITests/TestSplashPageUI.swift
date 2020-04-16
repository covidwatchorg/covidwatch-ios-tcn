//
//  Created by Zsombor Szabo on 11/03/2020.
//
//

import XCTest

class TestSplashPageUI: XCTestCase {

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

    func testSplashPage() {
        
        // Testing splash page has expected text
        XCTAssertEqual(XCUIApplication().staticTexts[AccessibilityIdentifier.TitleText.rawValue].label, "COVID WATCH")
        XCTAssertEqual(XCUIApplication().staticTexts[AccessibilityIdentifier.DescriptionText.rawValue].label,
                       "Help your community stay safe, anonymously.")
        //XCTAssertEqual(XCUIApplication().buttons[AccessibilityIdentifier.StartButton.rawValue].label, "")
        
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
