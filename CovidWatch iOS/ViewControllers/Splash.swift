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
    @IBOutlet weak var btnHeight: NSLayoutConstraint!

    static let animationDuration = 1.0
    static let animationSlowdown = 1.5
    static let delayBetweenAnimations = 0.2

    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.update(height: btnHeight)
        // prepare for animation
        self.startButton.alpha = 0.0
        self.descriptionText.alpha = 0.0
        // accessibility identifiers
        setupAccessibilityAndLocalization()

        if UserDefaults.standard.checkIfStartedOnboarding && UserDefaults.standard.isFirstTimeUser {
            DispatchQueue.main.async {
                self.goToBluetoothNoAnimation()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // animate bottom elements in
        UIView.animate(withDuration: Self.animationDuration, animations: {
            self.descriptionText.alpha = 1.0
        }, completion: { _ in
            // now that description text is visible,
            // decide if we animate the button in or go to Home
            if UserDefaults.standard.isFirstTimeUser {
                UIView.animate(withDuration: Self.animationDuration * Self.animationSlowdown,
                               delay: Self.delayBetweenAnimations,
                               animations: {
                    self.startButton.alpha = 1.0
                })
            } else {
                // fast track to Home if you've done all this already
                self.performSegue(withIdentifier: "\(Home.self)", sender: self)
            }
        })
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
