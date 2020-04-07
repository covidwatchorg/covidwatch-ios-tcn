//
//  Header.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Header: UIView {
    var logo: UIImageView {
        let logo = UIImageView(image: UIImage(named: "logo-cw-color"))
        logo.frame.size.width = 41
        logo.frame.size.height = 39
        logo.center.x = 0.1 * self.frame.size.width
        logo.center.y = self.frame.size.height / 2
        return logo
    }
    var menu: UIImageView {
    let menu = UIImageView(image: UIImage(named: "menu-icon"))
        menu.frame.size.width = 36
        menu.frame.size.height = 24
        menu.center.x = 0.9 * self.frame.size.width
        menu.center.y = self.frame.size.height / 2
        return menu
    }
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1))
        print(UIScreen.main.bounds.height * 0.1)
        self.addSubview(self.logo)
        self.addSubview(self.menu)
        self.backgroundColor = .white

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
