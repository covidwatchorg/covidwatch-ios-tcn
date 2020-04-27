//
//  UIViewExtension.swift
//  CovidWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  
//

import UIKit

extension UIResponder {
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
    var figmaScreenWidth: CGFloat {
        get {
            return 375.0
        }
    }
    var figmaScreenHeight: CGFloat {
        get {
            return 812.0
        }
    }
    var figmaToiOSVerticalScalingFactor: CGFloat {
        get {
            return screenHeight/figmaScreenHeight
        }
    }
    var figmaToiOSHorizontalScalingFactor: CGFloat {
        get {
            return screenWidth/figmaScreenWidth
        }
    }
    var contentMaxWidth: CGFloat {
        get {
            return screenWidth - 40
        }
    }
    var mainLogoWidth: CGFloat {
        get {
            return 264.0 * figmaToiOSHorizontalScalingFactor
        }
    }
    var mainLogoHeight: CGFloat {
        get {
            return 164.0 * figmaToiOSVerticalScalingFactor
        }
    }
    var buttonHeight: CGFloat {
        get {
            return 58.0 * figmaToiOSVerticalScalingFactor
        }
    }
}
