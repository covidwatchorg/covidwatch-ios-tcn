//
//  UIViewExtension.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

extension UIViewController {
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
}
