//
//  AlertControllerTests.swift
//  CovidWatch iOSTests
//
//  Created by Jeff Lett on 4/26/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import XCTest
@testable import Covid_Watch

class AlertControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBluetoothAlert() throws {
        let alert = UIAlertController.bluetoothAlert
        
        //validate title
        guard let title = alert.title else {
            XCTFail("Expected Title in Bluetooth UIAlertController")
            return
        }
        XCTAssertFalse(title.isEmpty)
        
        //validate message
        guard let message = alert.message else {
            return XCTFail("Expected Message in Bluetooth UIAlertController")
        }
        XCTAssertFalse(message.isEmpty)
        
        //validate actions
        XCTAssertEqual(1, alert.actions.count)
        guard let action = alert.actions.first else {
            return XCTFail("Expected Action on Bluetooth UIAlertController")
        }
        XCTAssertTrue(action.isEnabled)
    }
    
    func testNotificationAlert() throws {
        let alert = UIAlertController.notificationAlert
        
        //validate title
        guard let title = alert.title else {
            XCTFail("Expected Title in Notification UIAlertController")
            return
        }
        XCTAssertFalse(title.isEmpty)
        
        //validate message
        guard let message = alert.message else {
            return XCTFail("Expected Message in Notification UIAlertController")
        }
        XCTAssertFalse(message.isEmpty)
        
        //validate actions
        XCTAssertEqual(1, alert.actions.count)
        guard let action = alert.actions.first else {
            return XCTFail("Expected Action on Notification UIAlertController")
        }
        XCTAssertTrue(action.isEnabled)
    }

}
