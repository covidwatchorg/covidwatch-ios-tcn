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

    // swiftlint:disable:next function_body_length
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
        if let linkImg = linkImg {
            linkImg.frame.size.height = menuItem1text.frame.size.height
            linkImg.frame.size.width = linkImg.frame.size.height
            linkImg.center.y = menuItem1.center.y
            linkImg.frame.origin.x = menuItem1.frame.maxX - linkImg.frame.size.width
            linkImg.isHidden = true
        }
        menuItem1text.isHidden = true
        menuItem1.isHidden = true
        linkImg?.layer.zPosition = 1
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
           
           if let linkImg = self.linkImg {
               linkImg.isHidden = !linkImg.isHidden
        }
               if  menuItem1.isHidden == true {
                   UIView.animate(withDuration: 1.0,
                   delay: 0.0,
                              options: [],
                              animations: { [weak self] in
                               if let controller = self {
                                   controller.menuItem1.center.x =  1000
                                     controller.menuItem1text.center.x =  1000
                                   
                                    controller.linkImg?.frame.origin.x =  controller.menuItem1text.frame.origin.x
                               }
                   }, completion: nil)
                   }
                if  menuItem1.isHidden == false {
               UIView.animate(withDuration: 1.0,
                                               delay: 0.0,
                                                          options: [],
                                                          animations: { [weak self] in
                                                           if let controller = self {
                                                            // swiftlint:disable:next line_length
                                                            controller.menuItem1.frame.origin.x =  0.9 * controller.screenWidth - controller.menuItem1.frame.width/1.14
                                                            // swiftlint:disable:next line_length
                                                                 controller.menuItem1text.frame.origin.x =  0.9 * controller.screenWidth - controller.menuItem1text.frame.width/1.14
                                                               // swiftlint:disable:next line_length
                                                                controller.linkImg?.frame.origin.x = controller.menuItem1text.frame.origin.x + 210
                                              
                                                           }
                                               }, completion: nil)
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
