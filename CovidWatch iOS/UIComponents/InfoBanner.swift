//
//  Title.swift
//  CovidWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  
//

import UIKit

class InfoBanner: UIView {
    weak var parentVC: UIViewController!
    var text = UITextView()
    var isInteractive: Bool = false
    let exclamationCircle = UIImageView(image: UIImage(named: "exclamation-circle"))
    let buttonArrow = UIImageView(image: UIImage(named: "button-arrow"))
    private var _onClick: () -> Void = {return}
    init(_ parentVC: UIViewController, text: String, onClick: @escaping () -> Void) {
        self.parentVC = parentVC
        self._onClick = onClick
        super.init(frame: CGRect())
        
        self.frame.size.width = screenWidth
        self.frame.size.height = 100 * figmaToiOSVerticalScalingFactor
        self.backgroundColor = UIColor.Secondary.Tangerine
        
        self.text = UITextView()
        self.text.text = text
        self.text.font = Font.main.font(viewHeight: screenHeight)
        self.text.textColor = .white
        self.text.isEditable = false
        self.text.isSelectable = false
        self.text.backgroundColor = .clear
        
        self.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
        self.text.addGestureRecognizer(
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
    
    func draw(centerX: CGFloat, originY: CGFloat) {
        self.center.x = centerX
        self.frame.origin.y = originY
        if isInteractive {
            text.frame.size.width = 250 * figmaToiOSHorizontalScalingFactor
        } else {
            text.frame.size.width = 290 * figmaToiOSHorizontalScalingFactor
        }
        text.frame.size.height = text.contentSize.height
        text.center.x = self.center.x
        text.center.y = self.center.y
        text.backgroundColor = .clear
        if isInteractive {
            self.exclamationCircle.isHidden = false
            self.exclamationCircle.frame.size.width = 35.0 * figmaToiOSHorizontalScalingFactor
            self.exclamationCircle.frame.size.height = self.exclamationCircle.frame.size.width
            //swiftlint:disable:next line_length
            self.exclamationCircle.frame.origin.x = self.text.frame.origin.x - self.exclamationCircle.frame.size.width - (15 * figmaToiOSHorizontalScalingFactor)
            self.exclamationCircle.center.y = self.text.center.y
            self.buttonArrow.isHidden = false
            self.buttonArrow.frame.size.height = 24 * figmaToiOSVerticalScalingFactor
            self.buttonArrow.frame.size.width = (13.33/24.0) * self.buttonArrow.frame.size.height
            self.buttonArrow.center.y = self.text.center.y
            //swiftlint:disable:next line_length
            self.buttonArrow.frame.origin.x = self.text.frame.origin.x + self.text.frame.size.width + 18 * figmaToiOSHorizontalScalingFactor
        } else {
            self.exclamationCircle.isHidden = true
            self.buttonArrow.isHidden = true
        }
        
        parentVC.view.addSubview(self)
        parentVC.view.addSubview(self.text)
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
