//
//  SplashViewController.swift
//  CovidWatch iOS
//
//  Created by Laima Cernius-Ink on 4/4/20.
//  
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet var mainLogoImg: UIImageView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // accessibility identifiers
        setupAccessibilityAndLocalization()
        
        if UserDefaults.standard.get(.onboardingStarted) ?? false {
            DispatchQueue.main.async {
                self.goToBluetooth()
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
        self.performSegue(withIdentifier: "\(Bluetooth.self)", sender: self)
    }

}
