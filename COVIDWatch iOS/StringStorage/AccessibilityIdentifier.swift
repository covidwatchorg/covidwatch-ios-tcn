//
//  AccessibilityIdentifier.swift
//  COVIDWatch
//
//  Created by Hayden Riddiford on 4/16/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation

/**
A centralized place to store strings for accessibility identifiers for applicaiton and UI testing use.
These will not be read to the user so don't need to be localized.
 */

enum AccessibilityIdentifier: String {
    case
    
    // MARK: Splash page
    TitleText = "Title",
    StartButton = "Start",
    DescriptionText = "Description",
    
    // MARK: Bluetooth page
    LargeText = "a",
    MainText = "b",
    AllowButton = "c"
    
}
