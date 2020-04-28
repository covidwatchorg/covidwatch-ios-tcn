//
//  FontType.swift
//  CovidWatch iOS
//
//  Created by Jeff Lett on 4/27/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

enum Font {
    case main, large, subtext, button
    
    func font(viewHeight: CGFloat) -> UIFont? {
        let size = fontSize(viewHeight: viewHeight)
        return font(fontSize: size)
    }
    
    private func font(fontSize: CGFloat) -> UIFont? {
        switch self {
        case .main, .subtext:
            return UIFont(name: "Montserrat", size: fontSize)
        case .button:
            return UIFont(name: "Montserrat-Bold", size: fontSize)
        case .large:
            return UIFont(name: "Montserrat-SemiBold", size: fontSize)
        }
    }
    
    private enum ScreenHeight: CGFloat {
        case small = 568
        case medium = 812
    }
    
    //swiftlint:disable cyclomatic_complexity
    private func fontSize(viewHeight: CGFloat) -> CGFloat {
        if viewHeight <= ScreenHeight.small.rawValue {
            switch self {
            case .large: return 28
            case .main, .button: return 14
            case .subtext: return 10
            }
        } else if viewHeight <= ScreenHeight.medium.rawValue {
            switch self {
            case .large: return 32
            case .main, .button: return 16
            case .subtext: return 12
            }
        } else {
            switch self {
            case .large: return 36
            case .main, .button: return 18
            case .subtext: return 14
            }
        }
    }
}
