//
//  Bluetooth.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Bluetooth: BaseViewController {
    var img = UIImageView(image: UIImage(named: "people-group-blue-2"))
    var largeText = LargeText(text: "Privately Connect")
    //swiftlint:disable:next line_length
    var mainText = MainText(text: "We use Bluetooth to anonymously log interactions with other Covid Watch users. Your personal data is always private and never shared.")
    var button = Button(text: "Allow Bluetooth", subtext: "This is required for the app to work.")

    var buttonRecognizer: UITapGestureRecognizer?
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = UIColor(hexString: "FFFFFF")

        img.frame.size.width = 312 * figmaToiOSHorizontalScalingFactor
        img.frame.size.height = 326.0 * figmaToiOSVerticalScalingFactor
        if screenHeight <= 667 {
            img.frame.size.width /= 1.5
            img.frame.size.height /= 1.5
        }
        img.center.x = view.center.x
        img.frame.origin.y = header.frame.minY + (119.0 * figmaToiOSVerticalScalingFactor)
        view.addSubview(img)

        largeText.draw(parentVC: self,
                       centerX: view.center.x,
                       originY: img.frame.maxY + 20 * figmaToiOSVerticalScalingFactor)

        mainText.draw(parentVC: self, centerX: view.center.x, originY: largeText.frame.maxY)
        self.buttonRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.nextScreen))
        if let buttonRecognizer = self.buttonRecognizer {
            self.button.addGestureRecognizer(buttonRecognizer)
        }
        let buttonTop: CGFloat = 668.0 * figmaToiOSVerticalScalingFactor
        button.draw(parentVC: self, centerX: view.center.x, originY: buttonTop)
    }

    @objc func nextScreen(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.buttonRecognizer?.isEnabled = false // disable double tap
            BluetoothPermission.sharedInstance.checkPermission({ [weak self] in
                self?.buttonRecognizer?.isEnabled = true

                if UserDefaults.standard.isContactEventLoggingEnabled == false {
                    UserDefaults.standard.isContactEventLoggingEnabled = true
                }
                self?.performSegue(withIdentifier: "BluetoothToNotifications", sender: self)
            }, {
                self.buttonRecognizer?.isEnabled = true

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
                self.present(bluetoothSettingsAlert, animated: true)
                print("Please go into settings and enable Bluetooth")
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
