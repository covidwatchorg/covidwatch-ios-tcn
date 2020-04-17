//
//  Title.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class InfoBanner: UIView {
    var text: UITextView?
    init(text: String) {
        super.init(frame: CGRect())
        
        self.frame.size.width = screenWidth
        self.frame.size.height = 100 * figmaToiOSVerticalScalingFactor
        self.backgroundColor = UIColor.Secondary.Tangerine

        self.text = UITextView()
        var fontSize: CGFloat = 18
        if screenHeight <= 568 {
            fontSize = 14
        } else if screenHeight <= 667 {
            fontSize = 16
        }
        if let selfText = self.text {
            selfText.text = text
            selfText.font = UIFont(name: "Montserrat-Bold", size: fontSize)
            selfText.textColor = .white
            selfText.isEditable = false
            selfText.isSelectable = false
            selfText.frame.size.width = 290 * figmaToiOSHorizontalScalingFactor
            selfText.frame.size.height = selfText.contentSize.height
            selfText.backgroundColor = .clear
        }
    }

    func draw(parentVC: UIViewController, centerX: CGFloat, originY: CGFloat) {
        self.center.x = centerX
        self.frame.origin.y = originY
        self.text?.center.x = self.center.x
        self.text?.center.y = self.center.y
        parentVC.view.addSubview(self)
        if let selfText = self.text {
            parentVC.view.addSubview(selfText)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
