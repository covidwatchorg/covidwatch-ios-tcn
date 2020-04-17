//
//  Title.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class InfoBanner: UITextView {
    init(text: String) {
        super.init(frame: CGRect(), textContainer: nil)
        self.text = text
        var fontSize: CGFloat = 18
        if screenHeight <= 568 {
            fontSize = 14
        } else if screenHeight <= 667 {
            fontSize = 16
        }
        self.font = UIFont(name: "Montserrat-Bold", size: fontSize)
        self.textColor = .white
        self.frame.size.width = screenWidth
        self.frame.size.height = 130 * figmaToiOSVerticalScalingFactor
        self.isEditable = false
        self.backgroundColor = UIColor.Secondary.Tangerine
        self.isSelectable = false
        let verticalInset = 44   * figmaToiOSVerticalScalingFactor
        let horizontalInset = 43 * figmaToiOSHorizontalScalingFactor
        self.textContainerInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }

    func draw(parentVC: UIViewController, centerX: CGFloat, originY: CGFloat) {
        self.center.x = centerX
        self.frame.origin.y = originY
        parentVC.view.addSubview(self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
