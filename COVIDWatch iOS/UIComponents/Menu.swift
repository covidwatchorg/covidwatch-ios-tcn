//
//  Menu.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/7/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

let MANUAL_STATE_TEST = false

class Menu: UIView {
    weak var parentVC: BaseViewController?
    var xIcon = UIImageView(image: UIImage(named: "x-icon"))
    var menuItems: [MenuItem] = []
    var bottomWaterMark = UIImageView(image: UIImage(named: "collab-with-stanford"))
  var hide = true
    func draw() {

        drawMenuBackground()
        drawXIcon()
        drawMenuItems()
        drawBottomText()
    }
    
    private func drawMenuBackground() {
       
        self.frame.size.width = 0.8 * screenWidth
        self.frame.size.height = screenHeight
        self.frame.origin.x = screenWidth - self.frame.size.width + 1000
        if let parentVC = self.parentVC {
            self.frame.origin.y = 0
        
        self.backgroundColor = .white
        self.isHidden = false
        self.layer.zPosition = 1
        parentVC.view.addSubview(self)
        }
    }
    
    private func drawXIcon() {
        xIcon.frame.size.width = 23
        xIcon.frame.size.height = 23
        xIcon.center.x = 0.9 * screenWidth + 1000
        if let parentVC = self.parentVC {
            xIcon.center.y = (screenHeight * 0.1)/2 + parentVC.view.safeAreaInsets.top
        }
        xIcon.isHidden = false
        xIcon.isUserInteractionEnabled = true
        xIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleMenu)))
        xIcon.layer.zPosition = 1
        parentVC?.view.addSubview(xIcon)
    }
    
    private func drawMenuItems() {
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
            if let parentVC = self.parentVC {
                item.draw(parentVC: parentVC, width: menuItemWidth, centerX: self.center.x, centerY: yCenter)
            }
        }
    }
    
    private func drawBottomText() {
        bottomWaterMark.frame.size.width = screenWidth - 82.0 * figmaToiOSHorizontalScalingFactor
        bottomWaterMark.frame.size.height = (61.0/300.0) * bottomWaterMark.frame.size.width
        bottomWaterMark.center.x = self.center.x
        bottomWaterMark.center.y = screenHeight - (69.5 * figmaToiOSVerticalScalingFactor)
        //bottomWaterMark.isHidden = true
        bottomWaterMark.alpha = 0
        bottomWaterMark.layer.zPosition = 1
        parentVC?.view.addSubview(bottomWaterMark)
    }
    @objc func toggleMenu() {
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        
        for menuItem in menuItems {
            menuItem.toggleShow()
        }
       hide = !hide
        if  hide == true {
              self.bottomWaterMark.alpha = 0
            UIView.animate(
                withDuration: 1.0, delay: 0.0, options: [],
                animations: { [weak self] in
                    if let controller = self {
                        controller.frame.origin.x =  controller.screenWidth - controller.frame.size.width + 1000
                        controller.xIcon.frame.origin.x = 0.9 * controller.screenWidth + 1000
                       
                        
                    }
                }, completion: nil)
        }
        if  hide == false {

            UIView.animate(
                
                withDuration: 1.0, delay: 0.0, options: [],
                animations: { [weak self] in
                    if let controller = self {
                        controller.frame.origin.x =  controller.screenWidth - controller.frame.size.width
                        controller.xIcon.frame.origin.x = 0.9 * controller.screenWidth
                        
                        controller.bottomWaterMark.center.x = controller.center.x
                        controller.bottomWaterMark.alpha = 1
                    }
                }, completion: nil)
            
        }
        
    }
    
  
    // swiftlint:disable:next function_body_length
    init(_ parentVC: BaseViewController) {
        self.parentVC = parentVC
        super.init(frame: CGRect())
        if !MANUAL_STATE_TEST {
            self.menuItems.append(contentsOf: [
                MenuItem(parentVC, text: "Settings", addLinkImg: true, onClick: {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }),
                MenuItem(parentVC, text: "Test Results", addLinkImg: false, onClick: {
                    if let parentVC = self.parentVC {
                        parentVC.performSegue(withIdentifier: "test", sender: parentVC)
                    }
                }),
                MenuItem(parentVC, text: "How does this work?", addLinkImg: true, onClick: {
                    print("Clicked How does this work?") // Dummy function for now
                }),
                MenuItem(parentVC, text: "Covid Watch Website", addLinkImg: true, onClick: {
                    if let url = URL(string: "https://www.covid-watch.org/") {
                        UIApplication.shared.open(url)
                    }
                }),
                MenuItem(parentVC, text: "Health Guidlines", addLinkImg: true, onClick: {
                    if let url = URL(string: "https://www.cdc.gov/coronavirus/2019-nCoV/index.html") {
                        UIApplication.shared.open(url)
                    }
                }),
                MenuItem(parentVC, text: "Terms of Use", addLinkImg: true, onClick: {
                    print("Clicked Terms of Use") // Dummy function for now
                }),
                MenuItem(parentVC, text: "Privacy Policy", addLinkImg: true, onClick: {
                    print("Clicked Privacy Policy") // Dummy function for now
                })
            ])

        } else {
            let globalState = UserDefaults.shared
            let now = Date()
            let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: now)
            let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: now)
            self.menuItems.append(contentsOf: [
                MenuItem(parentVC, text: "mostRecentExposure-30d", addLinkImg: false, onClick: {
                    globalState.mostRecentExposureDate = thirtyDaysAgo
                    print("Set mostRecentExposureDate to 30 days ago")
                }),
                MenuItem(parentVC, text: "mostRecentExposure-3d", addLinkImg: false, onClick: {
                    globalState.mostRecentExposureDate = threeDaysAgo
                    print("Set mostRecentExposureDate to 3 days ago")
                }),
                MenuItem(parentVC, text: "mostRecentExposure-nil", addLinkImg: false, onClick: {
                    globalState.mostRecentExposureDate = nil
                    print("Set mostRecentExposureDate to nil")
                }),
                MenuItem(parentVC, text: "testLastSubmittedDate-30d", addLinkImg: false, onClick: {
                    globalState.testLastSubmittedDate = thirtyDaysAgo
                    print("Set testLastSubmittedDate to 30 days ago")
                }),
                MenuItem(parentVC, text: "testLastSubmittedDate-3d", addLinkImg: false, onClick: {
                    globalState.testLastSubmittedDate = threeDaysAgo
                    print("Set testLastSubmittedDate to 3 days ago")
                }),
                MenuItem(parentVC, text: "testLastSubmittedDate-nil", addLinkImg: false, onClick: {
                    globalState.testLastSubmittedDate = nil
                    print("Set testLastSubmittedDate to nil")
                }),
                MenuItem(parentVC, text: "Toggle isUserSick", addLinkImg: false, onClick: {
                    globalState.isUserSick = !globalState.isUserSick
                    print("isUserSick set to \(globalState.isUserSick)")
                    // Enforce that global state is realistic
                    globalState.testLastSubmittedDate = nil
                    print("Set testLastSubmittedDate to nil")
                })
            ])
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
