//
//  Bluetooth.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Notifications: BaseViewController {
    var img = UIImageView(image: UIImage(named: "phone-alerts"))
    var largeText: LargeText!
    var mainText: MainText!
    var button: Button!
    var buttonRecognizer: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.button = Button(self, text: "Allow Notifications", subtext: nil)
        //swiftlint:disable:next line_length
        self.mainText = MainText(self, text: "Enable notifications to receive anonymized alerts when you have come into contact with a confirmed case of COVID-19.")
        self.largeText = LargeText(self, text: "Recieve Alerts")
        NotificationCenter.default.addObserver(
            self, selector: #selector(nextScreenIfNotificationsEnabled),
            name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        Hide the Menu hamburger
        self.header.hasMenu = false
        self.view.backgroundColor = UIColor(hexString: "FFFFFF")

//        Ratio is Figma image width to Figma screen width

        img.frame.size.height = 324.0 * figmaToiOSVerticalScalingFactor
        img.frame.size.width = (326.0/324.0) * img.frame.size.height
        if screenHeight <= 667 {
            img.frame.size.width /= 1.2
            img.frame.size.height /= 1.2
        }
        img.center.x = view.center.x
        img.frame.origin.y = header.frame.minY + (106.0 * figmaToiOSVerticalScalingFactor)
        view.addSubview(img)

        let imgToLargeTextGap = 40.0 * figmaToiOSVerticalScalingFactor
        largeText.draw(centerX: view.center.x, originY: img.frame.maxY + imgToLargeTextGap)

        mainText.draw(centerX: view.center.x, originY: largeText.frame.maxY)

        self.buttonRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.nextScreen))
        if let buttonRecognizer = self.buttonRecognizer {
            self.button.addGestureRecognizer(buttonRecognizer)
        }

        let buttonTop: CGFloat = 668.0 * figmaToiOSVerticalScalingFactor
        self.button.draw(centerX: view.center.x, originY: buttonTop)
        // accessibility
        setupAccessibilityAndLocalization()
    }

    private func setupAccessibilityAndLocalization() {
        largeText.accessibilityIdentifier = AccessibilityIdentifier.LargeText.rawValue
        mainText.accessibilityIdentifier = AccessibilityIdentifier.MainText.rawValue
        button.accessibilityIdentifier = AccessibilityIdentifier.AllowButton.rawValue
        button.accessibilityLabel = AccessibilityLabel.allowButton
    }

    @objc func nextScreenIfNotificationsEnabled() {
        _ = NotificationPermission { [weak self] (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "NotificationsToFinish", sender: self)
                }
            case .failure(let error):
                print("Still no notifications permissions", error)
            }
        }
    }

    @objc func nextScreen(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.buttonRecognizer?.isEnabled = false
            _ = NotificationPermission { [weak self] result in
                self?.buttonRecognizer?.isEnabled = true
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.performSegue(withIdentifier: "NotificationsToFinish", sender: self)
                    }
                case .failure:
                    let notificationsSettingsAlert = UIAlertController(
                        title: NSLocalizedString("Notifications Required", comment: ""),
                        message: "Please turn on Notifications in Settings", preferredStyle: .alert
                    )
                    notificationsSettingsAlert.addAction(
                        UIAlertAction(
                            title: NSLocalizedString("Open Settings", comment: ""),
                            style: .default,
                            handler: { _ in
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                    )
                    DispatchQueue.main.async {
                        self?.present(notificationsSettingsAlert, animated: true)
                    }
                    print("Please go into settings and enable Notifications")
                }
            }
        }
    }
}
