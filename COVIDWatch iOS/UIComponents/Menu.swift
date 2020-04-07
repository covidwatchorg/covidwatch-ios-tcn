//
//  Menu.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/7/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Menu: UIView {
    var xIcon = UIView()
    var menuItems: Array<MenuItem> = [
       MenuItem(text: "How does this work?")
    ]
    
    func draw(parentVC: UIViewController) {
        self.frame.size.width = 0.8 * UIScreen.main.bounds.width
        self.frame.size.height = UIScreen.main.bounds.height
        self.frame.origin.x = UIScreen.main.bounds.width - self.frame.size.width
        self.frame.origin.y = parentVC.view.safeAreaInsets.top
        self.isHidden = true
        self.backgroundColor = .red
        parentVC.view.addSubview(self)
        
        let menuItemWidth = (3.0/3.75) * self.frame.size.width
        menuItems[0].draw(parentVC: parentVC, width: menuItemWidth, centerX: self.center.x, centerY: self.center.y)
        
        parentVC.view.addSubview(xIcon)
        drawXIcon(parentVC: parentVC)
        
    }
        
    private func drawXIcon(parentVC: UIViewController) {
        xIcon.backgroundColor = UIColor(patternImage: UIImage(named: "x-icon")!)
        xIcon.frame.size.width = 28
        xIcon.frame.size.height = 28
        xIcon.center.x = 0.9 * UIScreen.main.bounds.width
        xIcon.center.y = (UIScreen.main.bounds.height * 0.1)/2 + parentVC.view.safeAreaInsets.top
        xIcon.isHidden = true
        xIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleMenu)))
        parentVC.view.addSubview(xIcon)
    }
    
    @objc func toggleMenu() {
        self.isHidden = !self.isHidden
        xIcon.isHidden = !xIcon.isHidden
        for menuItem in menuItems {
            menuItem.toggleShow()
        }
    }
    
    init() {
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
