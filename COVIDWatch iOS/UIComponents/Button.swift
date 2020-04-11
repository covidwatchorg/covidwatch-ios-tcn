//
//  Header.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Button: UIView {
    var text = UILabel()
    var subtext: UITextView?

    init(text: String, subtext: String?) {
        super.init(frame: CGRect())
        self.text.text = text
        if subtext != nil {
            self.subtext = UITextView()
        }
        self.subtext?.text = subtext

        self.frame.size.width = contentMaxWidth
        self.frame.size.height = (58.0/321.0) * contentMaxWidth
        self.backgroundColor = UIColor(hexString: "496FB6")
        self.layer.cornerRadius = 10
        var buttonFontSize: CGFloat = 18
        var subtextFontSize: CGFloat = 14
        if screenHeight <= 568 {
            subtextFontSize = 10
            buttonFontSize = 14
        } else if screenHeight <= 667 {
            subtextFontSize = 12
            buttonFontSize = 16
        }
        self.text.font = UIFont(name: "Montserrat-Bold", size: buttonFontSize)
        self.text.textColor = .white
        self.text.backgroundColor = .clear
        self.subtext?.font = UIFont(name: "Montserrat", size: subtextFontSize)
        self.subtext?.textColor = UIColor(hexString: "585858")
        self.subtext?.backgroundColor = .clear
        self.subtext?.textAlignment = .center
        self.subtext?.isEditable = false
    }

//    Call this after you set where you want to place your button in the parentVC
    func draw(parentVC: UIViewController, centerX: CGFloat, centerY: CGFloat) {

        self.center.x = centerX
        self.center.y = centerY
        parentVC.view.addSubview(self)
        drawText(parentVC: parentVC)
    }

    func draw(parentVC: UIViewController, centerX: CGFloat, originY: CGFloat) {

        self.center.x = centerX
        self.frame.origin.y = originY
        parentVC.view.addSubview(self)
        drawText(parentVC: parentVC)
    }

    func drawText(parentVC: UIViewController) {
//        Call after the button's container has been laid out in parent ViewController
        self.text.sizeToFit()
        self.text.center = self.center
        parentVC.view.addSubview(self.text)
        self.subtext?.frame.size.width = contentMaxWidth
        self.subtext?.frame.size.height = self.subtext?.contentSize.height ?? 0
        self.subtext?.center.x = self.text.center.x
        self.subtext?.frame.origin.y = self.frame.maxY
        if self.subtext != nil {
            parentVC.view.addSubview(self.subtext!)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
