//
//  UIViewExtension.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

enum LinePosition {
    case top
    case bottom
}

extension UIView {
//    let screenWidth = screenWidth
//    let screenHeight = screenHeight
    var screenWidth: CGFloat {
        get {
            return UIScreen.main.bounds.width
        }
    }
    var screenHeight: CGFloat {
        get {
            return UIScreen.main.bounds.height
        }
    }
    var contentMaxWidth: CGFloat {
        get {
            screenWidth * (321.0/375.0)
        }
    }

    func addLine(position: LinePosition, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)

        let metrics = ["width": NSNumber(value: width)]
        let views = ["lineView": lineView]
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[lineView]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views)
        )

        switch position {
        case .top:
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[lineView(width)]",
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views
                )
            )
        case .bottom:
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:[lineView(width)]|",
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views
                )
            )
        }
    }
}
