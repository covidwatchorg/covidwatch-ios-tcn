//
//  Title.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class MainText: UITextView {
    init(text: String) {
        super.init(frame: CGRect(), textContainer: nil)
        self.text = text
    }
    
    func draw(parentVC: UIViewController, centerX: CGFloat, originY: CGFloat) {
        self.font = UIFont(name: "Montserrat", size: 18)
        self.textColor = UIColor(hexString: "585858")
        self.frame.size.width = contentMaxWidth
        self.frame.size.height = self.contentSize.height
        self.isEditable = false
        self.center.x = centerX
        self.frame.origin.y = originY
        self.backgroundColor = .clear
        parentVC.view.addSubview(self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
