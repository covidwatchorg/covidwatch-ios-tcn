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
    var linkImg: UIView?

    func draw(parentVC: UIViewController, width: CGFloat, centerX: CGFloat, centerY: CGFloat) {
        menuItem1.frame.size.width = width
        menuItem1.center.x = centerX
        menuItem1.center.y = centerY
        menuItem1text.font = UIFont(name: "Montserrat-Bold", size: 18)
        menuItem1text.textColor = UIColor(hexString: "585858")
        menuItem1text.sizeToFit()
        menuItem1text.frame.size.width = menuItem1.frame.size.width
        menuItem1.frame.size.height = (38.0/812.0) * screenHeight
        menuItem1text.center = menuItem1.center
        menuItem1.addLine(position: .bottom, color: UIColor(hexString: "CCCCCC"), width: 0.5)
        if linkImg != nil {
            linkImg = UIView()
            linkImg!.backgroundColor = UIColor(patternImage: UIImage(named: "launch-black-48dp")!)
            linkImg!.frame.size.height = menuItem1text.frame.size.height
            linkImg!.frame.size.width = linkImg!.frame.size.height
            linkImg!.center.y = menuItem1.center.y
            linkImg!.frame.origin.x = menuItem1.frame.maxX - linkImg!.frame.size.width
            linkImg?.isHidden = true
        }
        menuItem1text.isHidden = true
        menuItem1.isHidden = true

        parentVC.view.addSubview(menuItem1)
        parentVC.view.addSubview(menuItem1text)
        if linkImg != nil {
            parentVC.view.addSubview(linkImg!)
        }
    }

    func toggleShow() {
        menuItem1.isHidden = !menuItem1.isHidden
        menuItem1text.isHidden = !menuItem1text.isHidden
        if linkImg != nil {
            linkImg!.isHidden = !linkImg!.isHidden
        }
    }

    @objc func itemClickedCallback() {
        self.isHidden = !self.isHidden
    }

    init(text: String, addLinkImg: Bool = false) {
        self.menuItem1text.text = text
        if addLinkImg {
            linkImg = UIView()
        }
        super.init(frame: CGRect())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
