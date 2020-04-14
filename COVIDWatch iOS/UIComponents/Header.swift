//
//  Header.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Header: UIView {
    var logo = UIImageView(image: UIImage(named: "logo-cw-color"))
    var menuIcon = UIImageView(image: UIImage(named: "menu-icon"))
    var menu = Menu()
    private var _hasMenu: Bool = true
    var hasMenu: Bool {
        get {
            return _hasMenu
        }
        set (val) {
            self._hasMenu = val
            if val {
                self.menuIcon.isHidden = false
            } else {
                self.menuIcon.isHidden = true
            }

        }
    }

    init() {
        super.init(frame: CGRect())
        self.frame.size.width = screenWidth
        self.frame.size.height = screenHeight * 0.1
    }

    func draw(parentVC: UIViewController) {
        self.frame.origin.y = parentVC.view.safeAreaInsets.top
        drawLogo(parentVC: parentVC)
        drawMenuIcon(parentVC: parentVC)
    }

    private func drawLogo(parentVC: UIViewController) {
        logo.frame.size.width = 35
        logo.frame.size.height = 35
//        line up logo with the rest of the left hand content
        logo.frame.origin.x = (screenWidth - contentMaxWidth) / 2
        logo.center.y = self.frame.midY
        parentVC.view.addSubview(logo)
    }

    private func drawMenuIcon(parentVC: UIViewController) {
        menuIcon.frame.size.width = 36
        menuIcon.frame.size.height = 25
//        line up menu icon with the rest of the right hand content
        menuIcon.center.x = 0.9 * screenWidth
        menuIcon.frame.origin.x = screenWidth - ((screenWidth - contentMaxWidth) / 2) - menuIcon.frame.size.width
        menuIcon.center.y = self.frame.midY
        menuIcon.isUserInteractionEnabled = true
        menuIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleMenu)))
        parentVC.view.addSubview(menuIcon)
        parentVC.view.bringSubviewToFront(menuIcon)
    }

    @objc func toggleMenu() {
        menu.toggleMenu()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
