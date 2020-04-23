//
//  AccessibilityIdentifier.swift
//  CovidWatch
//
//  Created by Hayden Riddiford on 4/16/20.
//  
//

import Foundation

/**
A centralized place to store strings for accessibility identifiers for applicaiton and UI testing use.
These will not be read to the user so don't need to be localized.
 */

enum AccessibilityIdentifier: String {
    case
    
    // MARK: Splash page
    TitleLogo = "Title",
    StartButton = "Start",
    DescriptionText = "Description",
    
    // MARK: Bluetooth page
    LargeText = "large-text",
    MainText = "main-text",
    AllowButton = "allow-button",
    
    // MARK: UI Elements
    Content = "content",
    SubText = "sub-text",
    ButtonText = "button-text"
    
}
