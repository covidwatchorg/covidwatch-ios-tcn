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
    var isInteractive: Bool = false
    let exclamationCircle = UIImageView(image: UIImage(named: "exclamation-circle"))
    let buttonArrow = UIImageView(image: UIImage(named: "button-arrow"))
    private var _onClick: () -> Void = {return}
    init(text: String, onClick: @escaping () -> Void) {
        self._onClick = onClick
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
            selfText.backgroundColor = .clear
        }

        self.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
        self.text?.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
        self.exclamationCircle.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
        self.buttonArrow.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
    }

    func draw(parentVC: UIViewController, centerX: CGFloat, originY: CGFloat) {
        self.center.x = centerX
        self.frame.origin.y = originY
        if let selfText = self.text {
            selfText.center.x = self.center.x
            selfText.center.y = self.center.y
            if isInteractive {
                selfText.frame.size.width = 250 * figmaToiOSHorizontalScalingFactor
            } else {
                selfText.frame.size.width = 290 * figmaToiOSHorizontalScalingFactor
            }
            selfText.frame.size.height = selfText.contentSize.height
            selfText.backgroundColor = .clear
        }
        if isInteractive {
            self.exclamationCircle.isHidden = false
            self.exclamationCircle.frame.size.width = 35.0 * figmaToiOSHorizontalScalingFactor
            self.exclamationCircle.frame.size.height = self.exclamationCircle.frame.size.width
            //swiftlint:disable:next line_length
            self.exclamationCircle.frame.origin.x = (self.text?.frame.origin.x ?? 0) - self.exclamationCircle.frame.size.width - (15 * figmaToiOSHorizontalScalingFactor)
            self.exclamationCircle.center.y = self.text?.center.y ?? 0
            self.buttonArrow.isHidden = false
            self.buttonArrow.frame.size.height = 24 * figmaToiOSVerticalScalingFactor
            self.buttonArrow.frame.size.width = (13.33/24.0) * self.buttonArrow.frame.size.height
            self.buttonArrow.center.y = self.text?.center.y ?? 0
            //swiftlint:disable:next line_length
            self.buttonArrow.frame.origin.x = (self.text?.frame.origin.x ?? 0) + (self.text?.frame.size.width ?? 0) + 18 * figmaToiOSHorizontalScalingFactor
        } else {
            self.exclamationCircle.isHidden = true
            self.buttonArrow.isHidden = true
        }

        parentVC.view.addSubview(self)
        if let selfText = self.text {
            parentVC.view.addSubview(selfText)
        }
        parentVC.view.addSubview(self.exclamationCircle)
        parentVC.view.addSubview(self.buttonArrow)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func onClick() {
        if isInteractive {
            self._onClick()
        }
    }
}
