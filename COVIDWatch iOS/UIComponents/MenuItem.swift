//
//  Menu.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/7/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class MenuItem: UIView {
    let menuItem1 = UIView()
    let menuItem1text = UILabel()
    
    func draw(parentVC: UIViewController, width: CGFloat, centerX: CGFloat, centerY: CGFloat) {
        menuItem1.frame.size.width = width
        menuItem1.backgroundColor = .blue
        menuItem1.center.x = centerX
        menuItem1.center.y = centerY
        menuItem1text.font = UIFont(name: "Montserrat-Bold", size: 18)
        menuItem1text.sizeToFit()
        menuItem1text.frame.size.width = menuItem1.frame.size.width
        menuItem1.frame.size.height = menuItem1text.frame.size.height
        menuItem1text.center = menuItem1.center
        menuItem1text.isHidden = true
        menuItem1.isHidden = true

        parentVC.view.addSubview(menuItem1)
        parentVC.view.addSubview(menuItem1text)
        
    }
    
    func toggleShow() {
        menuItem1.isHidden = !menuItem1.isHidden
        menuItem1text.isHidden = !menuItem1text.isHidden
    }
        
    @objc func itemClickedCallback() {
        self.isHidden = !self.isHidden
    }
    
    init(text: String) {
        self.menuItem1text.text = text
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
