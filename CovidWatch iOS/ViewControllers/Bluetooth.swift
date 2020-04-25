//
//  Bluetooth.swift
//  CovidWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//  
//

import UIKit

class Bluetooth: UIViewController {
//    var img = UIImageView(image: UIImage(named: "bluetooth-image"))
//    var largeText: LargeText!
//    var mainText: MainText!
//    var button: Button!
//    var buttonRecognizer: UITapGestureRecognizer?
    var bluetoothPermission: BluetoothPermission?
    
    var isCheckingBluetoothPermissions = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let header = segue.destination as? HeaderViewController {
            header.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.button = Button(self, text: "Allow Bluetooth", subtext: "This is required for the app to work.")
//        //swiftlint:disable:next line_length
//        self.mainText = MainText(self, text: "We use Bluetooth to anonymously log interactions with other Covid Watch users. Your personal data is always private and never shared.")
//        self.largeText = LargeText(self, text: "Privately Connect")
        setupAccessibilityAndLocalization()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        img.frame.size.height = 326.0 * figmaToiOSVerticalScalingFactor
//        img.frame.size.width = (312.0/326.0) * img.frame.size.height
//        if screenHeight <= 667 {
//            img.frame.size.width /= 1.2
//            img.frame.size.height /= 1.2
//        }
//        img.center.x = view.center.x
//        img.frame.origin.y = header.frame.minY + (119.0 * figmaToiOSVerticalScalingFactor)
//        view.addSubview(img)
//
//        largeText.draw(centerX: view.center.x,
//                       originY: img.frame.maxY + 20 * figmaToiOSVerticalScalingFactor)
//
//        mainText.draw(centerX: view.center.x, originY: largeText.frame.maxY)
//        self.buttonRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.nextScreen))
//        if let buttonRecognizer = self.buttonRecognizer {
//            self.button.addGestureRecognizer(buttonRecognizer)
//        }
//        let buttonTop: CGFloat = 668.0 * figmaToiOSVerticalScalingFactor
//        button.draw(centerX: view.center.x, originY: buttonTop)1
    }
    
    private func setupAccessibilityAndLocalization() {
//        largeText.accessibilityIdentifier = AccessibilityIdentifier.LargeText.rawValue
//        mainText.accessibilityIdentifier = AccessibilityIdentifier.MainText.rawValue
//        button.accessibilityIdentifier = AccessibilityIdentifier.AllowButton.rawValue
//        button.accessibilityLabel = AccessibilityLabel.allowButton
    }
    
    func nextScreen() {
        self.isCheckingBluetoothPermissions = true
        self.bluetoothPermission = BluetoothPermission { [weak self] (result) in
            self?.isCheckingBluetoothPermissions = false
            switch result {
            case .success:
                if UserDefaults.standard.isContactTracingEnabled == false {
                    UserDefaults.standard.isContactTracingEnabled = true
                }
                self?.performSegue(withIdentifier: "BluetoothToNotifications", sender: self)
            case .failure:
                print("Please go into settings and enable Bluetooth")
                self?.present(UIAlertController.bluetoothAlert, animated: true)
            }
        }
    }
}

// MARK: - Protocol HeaderViewControllerDelegate
extension Bluetooth: HeaderViewControllerDelegate {
    func menuWasTapped() {
        print("Menu Was Tapped!")
        self.nextScreen()
    }
    var shouldShowMenu: Bool { true }
}

extension UIAlertController {
    static var bluetoothAlert: UIAlertController {
        let alert = UIAlertController(title: NSLocalizedString("Bluetooth Required", comment: ""),
                                      message: "Please turn on Bluetooth in Settings",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Open Settings", comment: ""),
                                      style: .default,
                                      handler: { _ in
                                        guard let url = URL(string: UIApplication.openSettingsURLString) else {
                                            return
                                        }
                                        UIApplication.shared.open(url)
        }))
        return alert
    }
}
