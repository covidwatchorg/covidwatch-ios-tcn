//
//  Splash-4.swift
//  CovidWatch iOS
//
//  Created by Laima Cernius-Ink on 4/4/20.
//  
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

        // accessibility identifiers
        setupAccessibilityAndLocalization()
        
        if checkIfStartedOnboarding() {
            DispatchQueue.main.async {
                self.goToBluetoothNoAnimation()
            }
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
