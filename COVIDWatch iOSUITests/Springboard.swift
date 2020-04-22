//
//  Springboard.swift
//  COVIDWatch iOSUITests
//
//  Created by Isaiah Becker-Mayer on 4/21/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import XCTest

final class Springboard {

    private static var springboardApp = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    class func deleteApp(name: String) {
        XCUIApplication().terminate()

        springboardApp.activate()

        sleep(1)

        let appIcon = springboardApp.icons.matching(identifier: name).firstMatch
        if !appIcon.exists {
            return
        }
        appIcon.press(forDuration: 1.3)

        sleep(1)

        springboardApp.buttons["Delete App"].tap()

        let deleteButton = springboardApp.alerts.buttons["Delete"].firstMatch
        if deleteButton.waitForExistence(timeout: 5) {
            deleteButton.tap()
        }
    }
}
