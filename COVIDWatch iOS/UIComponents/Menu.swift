//
//  Menu.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/7/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

let MANUAL_STATE_TEST = true

class Menu: UIView {
    var xIcon = UIImageView(image: UIImage(named: "x-icon"))
    var menuItems: [MenuItem] = [
        MenuItem(text: "Settings", addLinkImg: false, onClick: {
            print("Clicked Settings") // Dummy function for now
        }),
        MenuItem(text: "Test Results", addLinkImg: false, onClick: {
            print("Clicked Test Results") // Dummy function for now
        }),
        MenuItem(text: "How does this work?", addLinkImg: true, onClick: {
            print("Clicked How does this work?") // Dummy function for now
        }),
        MenuItem(text: "Covid Watch Website", addLinkImg: true, onClick: {
            print("Clicked Covid Watch Website") // Dummy function for now
        }),
        MenuItem(text: "Health Guidlines", addLinkImg: true, onClick: {
            print("Clicked Health Guidlines") // Dummy function for now
        }),
        MenuItem(text: "Terms of Use", addLinkImg: true, onClick: {
            print("Clicked Terms of Use") // Dummy function for now
        }),
        MenuItem(text: "Privacy Policy", addLinkImg: true, onClick: {
            print("Clicked Privacy Policy") // Dummy function for now
        })
    ]
    var bottomWaterMark = UIImageView(image: UIImage(named: "collab-with-stanford"))

    func draw(parentVC: UIViewController) {
        drawMenuBackground(parentVC: parentVC)
        drawXIcon(parentVC: parentVC)
        drawMenuItems(parentVC: parentVC)
        drawBottomText(parentVC: parentVC)
    }

    private func drawMenuBackground(parentVC: UIViewController) {
        self.frame.size.width = 0.8 * screenWidth
        self.frame.size.height = screenHeight
        self.frame.origin.x = screenWidth - self.frame.size.width
        self.frame.origin.y = parentVC.view.safeAreaInsets.top
        self.backgroundColor = .white
        self.isHidden = true
        self.layer.zPosition = 1
        parentVC.view.addSubview(self)
    }

    private func drawXIcon(parentVC: UIViewController) {
        xIcon.frame.size.width = 23
        xIcon.frame.size.height = 23
        xIcon.center.x = 0.9 * screenWidth
        xIcon.center.y = (screenHeight * 0.1)/2 + parentVC.view.safeAreaInsets.top
        xIcon.isHidden = true
        xIcon.isUserInteractionEnabled = true
        xIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleMenu)))
        xIcon.layer.zPosition = 1
        parentVC.view.addSubview(xIcon)
    }

    private func drawMenuItems(parentVC: UIViewController) {
        let menuItemWidth = (3.0/3.75) * self.frame.size.width
        let firstItemYValue = 160.0 * figmaToiOSVerticalScalingFactor
        let menuItemYGap = 58.0 * figmaToiOSVerticalScalingFactor

        var lastYCenter: CGFloat = 0.0
        for (index, item) in self.menuItems.enumerated() {
            var yCenter: CGFloat
            if index == 0 {
                yCenter = firstItemYValue
            } else {
                yCenter = lastYCenter + menuItemYGap
            }
            lastYCenter = yCenter
            item.draw(parentVC: parentVC, width: menuItemWidth, centerX: self.center.x, centerY: yCenter)
        }
    }

    private func drawBottomText(parentVC: UIViewController) {
        bottomWaterMark.frame.size.width = screenWidth - 82.0 * figmaToiOSHorizontalScalingFactor
        bottomWaterMark.frame.size.height = (61.0/300.0) * bottomWaterMark.frame.size.width
        bottomWaterMark.center.x = self.center.x
        bottomWaterMark.center.y = screenHeight - (69.5 * figmaToiOSVerticalScalingFactor)
        bottomWaterMark.isHidden = true
        bottomWaterMark.layer.zPosition = 1
        parentVC.view.addSubview(bottomWaterMark)
    }

    @objc func toggleMenu() {
        self.isHidden = !self.isHidden
        xIcon.isHidden = !xIcon.isHidden
        for menuItem in menuItems {
            menuItem.toggleShow()
        }
        bottomWaterMark.isHidden = !bottomWaterMark.isHidden
    }

    init() {
        super.init(frame: CGRect())
        
        if MANUAL_STATE_TEST {
            self.menuItems.removeAll()
            let globalState = UserDefaults.shared
            let now = Date()
            let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: now)
            let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: now)
            self.menuItems.append(contentsOf: [
                MenuItem(text: "mostRecentExposure-30d", addLinkImg: false, onClick: {
                    globalState.mostRecentExposureDate = thirtyDaysAgo
                    print("Set mostRecentExposureDate to 30 days ago")
                }),
                MenuItem(text: "mostRecentExposure-3d", addLinkImg: false, onClick: {
                    globalState.mostRecentExposureDate = threeDaysAgo
                    print("Set mostRecentExposureDate to 3 days ago")
                }),
                MenuItem(text: "mostRecentExposure-nil", addLinkImg: false, onClick: {
                    globalState.mostRecentExposureDate = nil
                    print("Set mostRecentExposureDate to nil")
                }),
                MenuItem(text: "testLastSubmittedDate-30d", addLinkImg: false, onClick: {
                    globalState.testLastSubmittedDate = thirtyDaysAgo
                    print("Set testLastSubmittedDate to 30 days ago")
                }),
                MenuItem(text: "testLastSubmittedDate-3d", addLinkImg: false, onClick: {
                    globalState.testLastSubmittedDate = threeDaysAgo
                    print("Set testLastSubmittedDate to 3 days ago")
                }),
                MenuItem(text: "testLastSubmittedDate-nil", addLinkImg: false, onClick: {
                    globalState.testLastSubmittedDate = nil
                    print("Set testLastSubmittedDate to nil")
                }),
                MenuItem(text: "Toggle isUserSick", addLinkImg: false, onClick: {
                    globalState.isUserSick = !globalState.isUserSick
                    print("isUserSick set to \(globalState.isUserSick)")
                    // Enforce that global state is realistic
                    globalState.testLastSubmittedDate = nil
                    print("Set testLastSubmittedDate to nil")
                }),
            ])
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
