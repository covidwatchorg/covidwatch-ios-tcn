//
//  TitleText.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/8/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class TitleText: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.textColor = UIColor(red: 0.941, green: 0.329, blue: 0.322, alpha: 1)
        self.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        self.frame.size.width = contentMaxWidth
        self.isEditable = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
