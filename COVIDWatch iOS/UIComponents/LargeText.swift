//
//  Title.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class LargeText: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.font = UIFont(name: "Montserrat-SemiBold", size: 36)
        self.textColor = UIColor(hexString: "585858")
        self.frame.size.width = contentMaxWidth()
        self.isEditable = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
