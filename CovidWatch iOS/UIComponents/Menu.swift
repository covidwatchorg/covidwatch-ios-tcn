//
//  Menu.swift
//  CovidWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/7/20.
//  
//

import UIKit

class Menu: UIView {
    weak var parentVC: UIViewController!
    var xIcon = UIImageView(image: UIImage(named: "x-icon"))
    var menuItems: [MenuItem] = []
    var bottomWaterMark = UIImageView(image: UIImage(named: "collab-with-stanford"))
    var fullScreenOpaqueOverlay = UIView()
    
    func draw() {
        //        draw functions all default menu to hidden (via setting the appropriate x position)
        drawFullScreenOpaqueOverlay()
        drawMenuBackground()
        drawXIcon()
        drawMenuItems()
        drawBottomText()
    }
    
    private func drawFullScreenOpaqueOverlay() {
        self.fullScreenOpaqueOverlay.frame.size.width = screenWidth
        self.fullScreenOpaqueOverlay.frame.size.height = screenHeight
        self.fullScreenOpaqueOverlay.frame.origin = CGPoint(x: 0, y: 0)
        self.fullScreenOpaqueOverlay.backgroundColor = .black
        self.fullScreenOpaqueOverlay.alpha = 0.0
        parentVC.view.addSubview(self.fullScreenOpaqueOverlay)
    }
    
    private func drawMenuBackground() {
        self.frame.size.width = 0.8 * screenWidth
        self.frame.size.height = screenHeight
        self.frame.origin.x = screenWidth
        self.frame.origin.y = 0
        self.backgroundColor = .white
        self.layer.zPosition = 1
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged))
        self.addGestureRecognizer(gesture)
        
        parentVC.view.addSubview(self)
    }
    
    private func drawXIcon() {
        xIcon.frame.size.width = 23
        xIcon.frame.size.height = 23
        xIcon.center.x = 0.9 * screenWidth + self.frame.size.width
        if let parentVC = self.parentVC {
            xIcon.center.y = (screenHeight * 0.1)/2 + parentVC.view.safeAreaInsets.top
        }
        xIcon.isUserInteractionEnabled = true
        xIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleMenu)))
        xIcon.layer.zPosition = 1
        parentVC.view.addSubview(xIcon)
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
            item.draw(
                width: menuItemWidth,
                centerX: self.center.x,
                centerY: yCenter
            )
        }
    }
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        // swiftlint:disable:next line_length
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            let translation = gestureRecognizer.translation(in: parentVC.view)
//            don't let user drag menu further leftwards than we want them to
            if self.frame.origin.x + translation.x >= screenWidth - 0.8 * screenWidth {
                self.translateMenuX(translation.x)
            }
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.parentVC.view)
        } else {
            if self.frame.origin.x < self.screenWidth * (1.0/3.0) {
                showMenu()
            } else {
                hideMenu()
            }
        }
        
    }
    
    private func drawBottomText() {
        bottomWaterMark.frame.size.width = screenWidth - 82.0 * figmaToiOSHorizontalScalingFactor
        bottomWaterMark.frame.size.height = (61.0/300.0) * bottomWaterMark.frame.size.width
        bottomWaterMark.center.x = self.center.x
        bottomWaterMark.center.y = screenHeight - (69.5 * figmaToiOSVerticalScalingFactor)
        bottomWaterMark.layer.zPosition = 1
        parentVC.view.addSubview(bottomWaterMark)
    }
    
    private var animationTimingFactor: CGFloat {
//        Factor to scale the animation timing linearly with how far the menu is being translated.
//        If we are moving the menu from fully hidden to fully visible, that will be longestAnim seconds.
        get {
            let longestAnim: CGFloat = 0.6
            return longestAnim / self.frame.size.width
        }
    }
    
    private func animationLength(forXTranslation xTranslation: CGFloat) -> TimeInterval {
//        swiftlint:disable:next line_length
        // Function to scale the animation timing linearly with how far the menu is being translated. So for example, if we are moving the menu from fully hidden to fully visible (forXTranslation == self.frame.size.width), that will be longestAnim seconds.
        let longestAnim: CGFloat = 0.6
        let animationTimingFactor = longestAnim / self.frame.size.width
        return TimeInterval(xTranslation * animationTimingFactor)
    }
    
    private func hideMenu() {
        let xTranslation = self.screenWidth - self.frame.origin.x
        UIView.animate(withDuration: animationLength(forXTranslation: xTranslation)) {
            self.translateMenuX(xTranslation)
            self.fullScreenOpaqueOverlay.alpha = 0.0
        }
    }
    
    private func showMenu() {
        let xTranslation = self.frame.origin.x - (self.screenWidth - self.frame.size.width)
        UIView.animate(withDuration: animationLength(forXTranslation: xTranslation)) {
            self.translateMenuX(-xTranslation)
            self.fullScreenOpaqueOverlay.alpha = 0.5
        }
    }
    
    private func translateMenuX(_ xTranslation: CGFloat) {
        self.frame.origin.x += xTranslation
        self.xIcon.center.x += xTranslation
        for item in self.menuItems {
            item.translateXPosition(xTranslation)
        }
        self.bottomWaterMark.center.x += xTranslation
    }
    
    @objc func toggleMenu() {
        if self.frame.origin.x >= self.screenWidth {
            self.showMenu()
        } else {
            self.hideMenu()
        }
    }
    
    // swiftlint:disable:next function_body_length
    init(_ parentVC: UIViewController) {
        self.parentVC = parentVC
        super.init(frame: CGRect())
        if getAppScheme() == .test {
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
        } else {
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
                MenuItem(parentVC, text: "How does this work?", addLinkImg: false, onClick: {
                    if let parentVC = self.parentVC {
                        
                        let pageView = PageViewController()
                        parentVC.present(pageView, animated: true, completion: nil)
//                        parentVC.performSegue(withIdentifier: "HomeToHowItWorks", sender: parentVC)
                    }
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
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
