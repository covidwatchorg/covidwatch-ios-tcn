//
//  Title.swift
//  CovidWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  
//

import UIKit

class ALLargeText: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.font = Font.large.font(viewHeight: screenHeight)
        self.accessibilityIdentifier = AccessibilityIdentifier.Content.rawValue
    }
}

class LargeText: UITextView {
    weak var parentVC: UIViewController!
    init(_ parentVC: UIViewController, text: String) {
        self.parentVC = parentVC
        super.init(frame: CGRect(), textContainer: nil)
        self.text = text
        self.font = Font.large.font(viewHeight: contentMaxWidth)
        self.textColor = UIColor.Primary.Gray
        self.frame.size.width = contentMaxWidth
        self.frame.size.height = self.contentSize.height
        self.isEditable = false
        self.backgroundColor = .clear
        self.isSelectable = false
        // accessibility
        self.accessibilityIdentifier = AccessibilityIdentifier.Content.rawValue
    }

    func draw(centerX: CGFloat, centerY: CGFloat) {
        self.center.x = centerX
        self.center.y = centerY
        parentVC.view.addSubview(self)
    }

    func draw(centerX: CGFloat, originY: CGFloat) {
        self.center.x = centerX
        self.frame.origin.y = originY
        parentVC.view.addSubview(self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
