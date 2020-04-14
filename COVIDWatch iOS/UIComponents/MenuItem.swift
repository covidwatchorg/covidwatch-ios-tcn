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
    var linkImg: UIImageView?
    private var _onClick: () -> Void = {return}

    func draw(parentVC: UIViewController, width: CGFloat, centerX: CGFloat, centerY: CGFloat) {
        menuItem1.isUserInteractionEnabled = true
        menuItem1text.isUserInteractionEnabled = true
        linkImg?.isUserInteractionEnabled = true
        self.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
        menuItem1.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
        menuItem1text.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
        linkImg?.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
        menuItem1.frame.size.width = width
        menuItem1.center.x = centerX
        menuItem1.center.y = centerY
        menuItem1text.font = UIFont(name: "Montserrat-Bold", size: 18)
        menuItem1text.textColor = UIColor(hexString: "585858")
        menuItem1text.sizeToFit()
        menuItem1text.frame.size.width = menuItem1.frame.size.width
        menuItem1.frame.size.height = (38.0 * figmaToiOSVerticalScalingFactor)
        menuItem1text.center = menuItem1.center
        menuItem1text.layer.zPosition = 1
        menuItem1.addLine(position: .bottom, color: UIColor(hexString: "CCCCCC"), width: 0.5)
        linkImg?.frame.size.height = menuItem1text.frame.size.height
        linkImg?.frame.size.width = linkImg!.frame.size.height
        linkImg?.center.y = menuItem1.center.y
        linkImg?.frame.origin.x = menuItem1.frame.maxX - linkImg!.frame.size.width
        linkImg?.isHidden = true
        linkImg?.layer.zPosition = 1
        menuItem1text.isHidden = true
        menuItem1.isHidden = true
        menuItem1text.layer.zPosition = 1
        menuItem1.layer.zPosition = 1

        parentVC.view.addSubview(menuItem1)
        parentVC.view.addSubview(menuItem1text)
        if let linkImg = self.linkImg {
            parentVC.view.addSubview(linkImg)
        }
    }

    func toggleShow() {
        menuItem1.isHidden = !menuItem1.isHidden
        menuItem1text.isHidden = !menuItem1text.isHidden
//        menuItem1.removeFromSuperview()
//        menuItem1.superview?.addSubview(menuItem1)
//        menuItem1.superview?.addSubview(menuItem1)
//        menuItem1text.superview?.addSubview(menuItem1text)
//        print(menuItem1.superview)
//        menuItem1.superview?.bringSubviewToFront(menuItem1)
//        menuItem1.layer.zPosition = 1000
//        menuItem1text.superview?.bringSubviewToFront(menuItem1text)
//        menuItem1text.layer.zPosition = 1000
        if let linkImg = self.linkImg {
//            linkImg.superview?.bringSubviewToFront(linkImg)
//            linkImg.layer.zPosition = 1000
            linkImg.isHidden = !linkImg.isHidden
//            linkImg.superview?.addSubview(linkImg)
        }
        
    }

    @objc func onClick() {
        self._onClick()
    }

    init(text: String, addLinkImg: Bool = false, onClick: @escaping () -> Void) {
        self.menuItem1text.text = text
        if addLinkImg {
            linkImg = UIImageView(image: UIImage(named: "launch-symbol"))
        }
        self._onClick = onClick
        super.init(frame: CGRect())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
