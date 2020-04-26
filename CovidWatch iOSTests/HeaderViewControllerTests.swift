//
//  HeaderViewControllerTests.swift
//  CovidWatch iOSTests
//
//  Created by Jeff Lett on 4/26/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import XCTest
@testable import Covid_Watch

class HeaderViewControllerTests: XCTestCase {
    
    private class MockHeaderDelegate: HeaderViewControllerDelegate {
        init(shouldShowMenu: Bool) {
            self.shouldShowMenu = shouldShowMenu
        }
        let shouldShowMenu: Bool
        
        func menuWasTapped() {
            self.wasMenuWasTappedCalled = true
        }
        var wasMenuWasTappedCalled = false
    }

    private var headerViewController: HeaderViewController!
    private var window = UIWindow()
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "\(HeaderViewController.self)", bundle: nil)
        headerViewController = storyboard.instantiateInitialViewController() as? HeaderViewController
    }
    
    func testDelegateIsCalledOnMenuTap() throws {
        let mockDelegate = MockHeaderDelegate(shouldShowMenu: true)
        headerViewController.delegate = mockDelegate
        window.addSubview(headerViewController.view)
        headerViewController.btnMenu.sendActions(for: .touchUpInside)
        XCTAssertTrue(mockDelegate.wasMenuWasTappedCalled)
    }
    
    func testMenuIsShown() throws {
        let mockDelegate = MockHeaderDelegate(shouldShowMenu: true)
        headerViewController.delegate = mockDelegate
        window.addSubview(headerViewController.view)
        XCTAssertFalse(headerViewController.btnMenu.isHidden)
    }
    
    func testMenuIsHidden() throws {
        let shouldBeHidden = true
        let mockDelegate = MockHeaderDelegate(shouldShowMenu: !shouldBeHidden)
        headerViewController.delegate = mockDelegate
        window.addSubview(headerViewController.view)
        let isHidden = headerViewController.btnMenu.isHidden
        XCTAssertTrue(isHidden == shouldBeHidden)
    }

}
