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
