//
//  HowItWorks.swift
//  CovidWatch iOS
//
//  Created by Nikhil Kumar on 4/23/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class HowItWorks: UIViewController {
    @IBOutlet weak var page1: UIView!
    @IBOutlet weak var page2: UIView!
    @IBOutlet weak var page3: UIView!
    @IBOutlet weak var page4: UIView!
    @IBOutlet weak var howItWorksLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var setupButton: UIButton!
    @IBOutlet var setupButtonHeight: NSLayoutConstraint!

    override func updateViewConstraints() {
        if let setupButtonHeight = self.setupButtonHeight {
            setupButtonHeight.constant = (58.0/321.0) * contentMaxWidth
        }
        super.updateViewConstraints()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: Splash.onboardingStartedKey)
        // since screen 4 does not have pages
        if let page1 = self.page1,
            let page2 = self.page2,
            let page3 = self.page3,
            let page4 = self.page4
        {
            page1.layer.cornerRadius = 10
            page2.layer.cornerRadius = 10
            page3.layer.cornerRadius = 10
            page4.layer.cornerRadius = 10
        }
        if let setupButton = self.setupButton {
            setupButton.layer.cornerRadius = 10
            var buttonFontSize: CGFloat = 18
            if screenHeight <= 568 {
                buttonFontSize = 14
            } else if screenHeight <= 667 {
                buttonFontSize = 16
            }
            setupButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: buttonFontSize)
        }

        var titleFontSize: CGFloat = 36
        if screenHeight <= 568 {
            titleFontSize = 28
        } else if screenHeight <= 667 {
            titleFontSize = 32
        }
        var fontSize: CGFloat = 18
        if screenHeight <= 568 {
            fontSize = 14
        } else if screenHeight <= 667 {
            fontSize = 16
        }
        howItWorksLabel.font = UIFont(name: "Montserrat", size: 14)
        howItWorksLabel.textColor = UIColor.Primary.Gray
        titleLabel.font = UIFont(name: "Montserrat-SemiBold", size: titleFontSize)
        titleLabel.textColor = UIColor.Primary.Gray
        descriptionLabel.font = UIFont(name: "Montserrat", size: fontSize)
        descriptionLabel.textColor = UIColor.Primary.Gray
    }
}
