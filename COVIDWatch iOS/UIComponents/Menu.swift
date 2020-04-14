//
//  Menu.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/7/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Menu: UIView {
    var xIcon = UIImageView(image: UIImage(named: "x-icon"))
    var menuItems: [MenuItem] = [
        MenuItem(text: "How does this work?", addLinkImg: false),
        MenuItem(text: "CDC Health Guidlines", addLinkImg: true),
        MenuItem(text: "Covid Watch Website", addLinkImg: true),
        MenuItem(text: "Terms of Use", addLinkImg: true),
        MenuItem(text: "Privacy Policy", addLinkImg: true),
        MenuItem(text: "Delete app data", addLinkImg: false)
    ]
    var covidWatchText = UILabel()

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
        covidWatchText.text = "Covid Watch"
        covidWatchText.font = UIFont(name: "Montserrat", size: 14)
        covidWatchText.textColor = UIColor(hexString: "CCCCCC")
        covidWatchText.sizeToFit()
        covidWatchText.center.x = self.center.x
        covidWatchText.center.y = screenHeight - (35.0 * figmaToiOSVerticalScalingFactor)
        covidWatchText.isHidden = true
        covidWatchText.layer.zPosition = 1
        parentVC.view.addSubview(covidWatchText)
    }

    @objc func toggleMenu() {
        self.isHidden = !self.isHidden
        xIcon.isHidden = !xIcon.isHidden
        for menuItem in menuItems {
            menuItem.toggleShow()
        }
        covidWatchText.isHidden = !covidWatchText.isHidden
    }

    init() {
        super.init(frame: CGRect())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
