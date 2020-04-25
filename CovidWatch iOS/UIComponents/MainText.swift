//
//  Title.swift
//  CovidWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  
//

import UIKit

class LargeTextLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.font = UIFont(name: "Montserrat-SemiBold", size: 36)
        self.accessibilityIdentifier = AccessibilityIdentifier.Content.rawValue
        self.applyCommonStyles()
    }
}

class MainTextLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.font = UIFont(name: "Montserrat", size: 18)
        self.accessibilityIdentifier = AccessibilityIdentifier.Content.rawValue
        self.applyCommonStyles()
    }
}

class SubtextLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.font = UIFont(name: "Montserrat", size: 14)
        self.accessibilityIdentifier = AccessibilityIdentifier.SubText.rawValue
        self.applyCommonStyles()
    }
}

extension UILabel {
    func applyCommonStyles() {
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
        self.textColor = UIColor.Primary.Gray
        self.backgroundColor = .clear
    }
}

class ALButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.titleLabel?.accessibilityIdentifier = AccessibilityIdentifier.ButtonText.rawValue
        self.layer.cornerRadius = 10
    }
}

class MainText: UITextView {
    weak var parentVC: BaseViewController!
    
    init(_ parentVC: BaseViewController, text: String) {
        self.parentVC = parentVC
        super.init(frame: CGRect(), textContainer: nil)
        self.text = text
        var fontSize: CGFloat = 18
        if screenHeight <= 568 {
            fontSize = 14
        } else if screenHeight <= 667 {
            fontSize = 16
        }
        self.font = UIFont(name: "Montserrat", size: fontSize)
        self.textColor = UIColor.Primary.Gray
        self.frame.size.width = contentMaxWidth
        self.frame.size.height = self.contentSize.height
        self.isEditable = false
        self.backgroundColor = .clear
        self.isSelectable = false
        // accessibility
        self.accessibilityIdentifier = AccessibilityIdentifier.Content.rawValue
    }

    func draw(centerX: CGFloat, originY: CGFloat) {
        self.frame.size.width = contentMaxWidth
        self.frame.size.height = self.contentSize.height
        self.center.x = centerX
        self.frame.origin.y = originY
        parentVC.view.addSubview(self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
