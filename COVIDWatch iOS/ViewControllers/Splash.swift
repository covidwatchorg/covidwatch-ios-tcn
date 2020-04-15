//
//  Splash-4.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Splash: UIViewController {

    @IBOutlet weak var titleText: UILabel!
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
        let colorTop = UIColor(red: 67.0 / 255.0, green: 196.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 44.0 / 255.0, green: 88.0 / 255.0, blue: 177.0 / 255.0, alpha: 1.0).cgColor

        let mainGradient = CAGradientLayer()
        mainGradient.colors = [colorTop, colorBottom]
        mainGradient.locations = [0.0, 1.0]
        mainGradient.frame = view.frame
        view.layer.insertSublayer(mainGradient, at: 0)

        titleText.text =  "COVID WATCH"
        titleText.textColor = .white
        titleText.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        titleText.sizeToFit()

        // description text
        descriptionText.text = "Help your community stay safe, anonymously."
        descriptionText.textColor = .white
        descriptionText.font = UIFont(name: "Montserrat-Medium", size: 22)
        descriptionText.textAlignment = .center
        descriptionText.backgroundColor = .clear
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

    func goToBluetooth() {
        self.performSegue(withIdentifier: "SplashToBluetooth", sender: self)
    }

    func goToBluetoothNoAnimation() {
        self.performSegue(withIdentifier: "SplashToBluetoothQuick", sender: self)
    }

    /*
    // MARK: - Navigation
​
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
