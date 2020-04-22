//
//  Splash-4.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Splash: UIViewController {

    @IBOutlet var mainLogoImg: UIImageView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var startButton: UIButton!

    // this happens if bluetooth is changed during onboarding and the user
    // gets bounced back to the start of onboarding when reloading the app
    static let onboardingStartedKey = "onboardingStarted"
    func checkIfStartedOnboarding() -> Bool {
        // defaults to false
        return UserDefaults.standard.bool(forKey: Splash.onboardingStartedKey)
    }
    func setOnboardingStarted() {
        UserDefaults.standard.set(true, forKey: Splash.onboardingStartedKey)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // background gradient
        self.view.backgroundColor = UIColor.clear
        let colorBottom = UIColor(red: 67.0 / 255.0, green: 196.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0).cgColor
        let colorTop = UIColor(red: 44.0 / 255.0, green: 88.0 / 255.0, blue: 177.0 / 255.0, alpha: 1.0).cgColor

        let mainGradient = CAGradientLayer()
        mainGradient.colors = [colorTop, colorBottom]
        mainGradient.locations = [0.0, 1.0]
        mainGradient.frame = view.frame
        view.layer.insertSublayer(mainGradient, at: 0)

        // description text
        descriptionText.text = "Help your community stay safe, anonymously."
        descriptionText.textColor = .white
        descriptionText.font = UIFont(name: "Montserrat-Medium", size: 22)
        descriptionText.textAlignment = .center
        descriptionText.backgroundColor = .clear
        
        // accessibility identifiers
        setupAccessibilityAndLocalization()
        
        if let startButton = self.startButton {
            let height = NSLayoutConstraint(
                item: startButton,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: (58.0/321.0) * contentMaxWidth
            )
            startButton.addConstraint(height)
            startButton.layer.cornerRadius = 10
            startButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 24)
            startButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextScreen)))
        }

        if checkIfStartedOnboarding() {
            DispatchQueue.main.async {
                self.goToBluetoothNoAnimation()
            }
        }
    }

    @objc func nextScreen(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.setOnboardingStarted()
            self.goToBluetooth()
        }
    }
    
    private func setupAccessibilityAndLocalization() {
        mainLogoImg.accessibilityIdentifier = AccessibilityIdentifier.TitleLogo.rawValue
        descriptionText.accessibilityIdentifier = AccessibilityIdentifier.DescriptionText.rawValue
        startButton.accessibilityIdentifier = AccessibilityIdentifier.StartButton.rawValue
        startButton.accessibilityLabel = AccessibilityLabel.startButton
    }
    
    func goToBluetooth() {
        self.performSegue(withIdentifier: "SplashToBluetooth", sender: self)
    }

    func goToBluetoothNoAnimation() {
        self.performSegue(withIdentifier: "SplashToBluetoothQuick", sender: self)
    }
}

// MARK: - Layout Constraints
extension Splash {
    override func updateViewConstraints() {
        mainLogoConstraints()
        descriptionTextConstraints()
        startButtonConstraints()

        super.updateViewConstraints()
    }

    func startButtonConstraints() {
        if let startButton = self.startButton {
            let height = NSLayoutConstraint(
                item: startButton,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: buttonHeight
            )
            let width = NSLayoutConstraint(
                item: startButton,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: contentMaxWidth
            )
            startButton.addConstraint(height)
            startButton.addConstraint(width)
        }
    }

    func descriptionTextConstraints() {
        if let descriptionText = self.descriptionText {
            let width = NSLayoutConstraint(
                item: descriptionText,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: contentMaxWidth
            )
            descriptionText.addConstraint(width)
        }
    }

    func mainLogoConstraints() {
        if let mainLogoImg = self.mainLogoImg {
            let width = NSLayoutConstraint(
                item: mainLogoImg,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: mainLogoWidth
            )
            let height = NSLayoutConstraint(
                item: mainLogoImg,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: mainLogoHeight
            )
            mainLogoImg.addConstraint(width)
            mainLogoImg.addConstraint(height)
        }
    }
}
