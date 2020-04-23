//
//  Bluetooth.swift
//  CovidWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//  
//

import UIKit

class Bluetooth: BaseViewController {
    var img = UIImageView(image: UIImage(named: "bluetooth-image"))
    var largeText: LargeText!
    var mainText: MainText!
    var button: Button!
    var buttonRecognizer: UITapGestureRecognizer?
    var bluetoothPermission: BluetoothPermission?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.button = Button(self, text: "Allow Bluetooth", subtext: "This is required for the app to work.")
        //swiftlint:disable:next line_length
        self.mainText = MainText(self, text: "We use Bluetooth to anonymously log interactions with other Covid Watch users. Your personal data is always private and never shared.")
        self.largeText = LargeText(self, text: "Privately Connect")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        Hide the Menu hamburger
        self.header.hasMenu = false

        img.frame.size.height = 326.0 * figmaToiOSVerticalScalingFactor
        img.frame.size.width = (312.0/326.0) * img.frame.size.height
        if screenHeight <= 667 {
            img.frame.size.width /= 1.2
            img.frame.size.height /= 1.2
        }
        img.center.x = view.center.x
        img.frame.origin.y = header.frame.minY + (119.0 * figmaToiOSVerticalScalingFactor)
        view.addSubview(img)

        largeText.draw(centerX: view.center.x,
                       originY: img.frame.maxY + 20 * figmaToiOSVerticalScalingFactor)

        mainText.draw(centerX: view.center.x, originY: largeText.frame.maxY)
        self.buttonRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.nextScreen))
        if let buttonRecognizer = self.buttonRecognizer {
            self.button.addGestureRecognizer(buttonRecognizer)
        }
        let buttonTop: CGFloat = 668.0 * figmaToiOSVerticalScalingFactor
        button.draw(centerX: view.center.x, originY: buttonTop)
        setupAccessibilityAndLocalization()
    }
    
    private func setupAccessibilityAndLocalization() {
        largeText.accessibilityIdentifier = AccessibilityIdentifier.LargeText.rawValue
        mainText.accessibilityIdentifier = AccessibilityIdentifier.MainText.rawValue
        button.accessibilityIdentifier = AccessibilityIdentifier.AllowButton.rawValue
        button.accessibilityLabel = AccessibilityLabel.allowButton
    }
    
    @objc func nextScreen(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.buttonRecognizer?.isEnabled = false // disable double tap
            self.bluetoothPermission = BluetoothPermission { [weak self] (result) in
                switch result {
                case .success:
                    self?.buttonRecognizer?.isEnabled = true

                    if UserDefaults.standard.isContactTracingEnabled == false {
                        UserDefaults.standard.isContactTracingEnabled = true
                    }
                    self?.performSegue(withIdentifier: "BluetoothToNotifications", sender: self)
                case .failure:
                    self?.buttonRecognizer?.isEnabled = true

                    let bluetoothSettingsAlert = UIAlertController(
                        title: NSLocalizedString("Bluetooth Required", comment: ""),
                        message: "Please turn on Bluetooth in Settings", preferredStyle: .alert
                    )
                    bluetoothSettingsAlert.addAction(
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
                    self?.present(bluetoothSettingsAlert, animated: true)
                    print("Please go into settings and enable Bluetooth")
                }
            }
        }
    }
}
