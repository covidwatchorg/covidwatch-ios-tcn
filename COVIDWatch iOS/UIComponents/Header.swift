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
    var menuIcon = UIView()
    var menu = Menu()
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1))
    }
    
    func draw(parentVC: UIViewController) {
        self.frame.origin.y = parentVC.view.safeAreaInsets.top
        drawLogo(parentVC: parentVC)
        drawMenuIcon(parentVC: parentVC)
        menu.draw(parentVC: parentVC)
    }
    
    private func drawLogo(parentVC: UIViewController) {
        logo.frame.size.width = 41
        logo.frame.size.height = 39
        logo.center.x = 0.1 * UIScreen.main.bounds.width
        logo.center.y = self.frame.midY
        parentVC.view.addSubview(logo)
    }

    private func drawMenuIcon(parentVC: UIViewController) {
        menuIcon.backgroundColor = UIColor(patternImage: UIImage(named: "menu-icon")!)
        menuIcon.frame.size.width = 36
        menuIcon.frame.size.height = 24
        menuIcon.center.x = 0.9 * UIScreen.main.bounds.width
        menuIcon.center.y = self.frame.midY
        menuIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleMenu)))
        parentVC.view.addSubview(menuIcon)
    }
    
    @objc func toggleMenu() {
//        menuIcon.isHidden = !menuIcon.isHidden
        menu.toggleMenu()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
