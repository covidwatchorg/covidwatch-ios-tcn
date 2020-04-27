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

    override func viewDidLoad() {
        super.viewDidLoad()

        // accessibility identifiers
        setupAccessibilityAndLocalization()
        
        if UserDefaults.standard.checkIfStartedOnboarding {
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

    func goToBluetoothNoAnimation() {
        self.performSegue(withIdentifier: "SplashToBluetoothQuick", sender: self)
    }
}
