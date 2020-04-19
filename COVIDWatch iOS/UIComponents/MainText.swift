//
//  Title.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class MainText: UITextView {
    weak var parentVC: BaseViewController?
    
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
    }

    func draw(centerX: CGFloat, originY: CGFloat) {
        self.frame.size.width = contentMaxWidth
        self.frame.size.height = self.contentSize.height
        self.center.x = centerX
        self.frame.origin.y = originY
        parentVC?.view.addSubview(self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
