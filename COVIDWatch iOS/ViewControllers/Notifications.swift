//
//  Bluetooth.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Notifications: BaseViewController {
    var img = UIImageView(image: UIImage(named: "people-standing-01-blue-4"))
    var largeText = LargeText(text: "Recieve Alerts")
    //swiftlint:disable:next line_length
    var mainText = MainText(text: "Enable notifications to receive anonymized alerts when you have come into contact with a confirmed case of COVID-19.")
    var button = Button(text: "Allow Notifications")
    var buttonRecognizer: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self, selector: #selector(nextScreenIfNotificationsEnabled),
            name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        Hide the Menu hamburger
        self.header?.hasMenu = false
        self.view.backgroundColor = UIColor(hexString: "FFFFFF")

//        Ratio is Figma image width to Figma screen width
        img.frame.size.width = 358.0 * figmaToiOSHorizontalScalingFactor
        img.frame.size.height = 252.0 * figmaToiOSVerticalScalingFactor
        if screenHeight <= 667 {
            img.frame.size.width /= 1.5
            img.frame.size.height /= 1.5
        }
        img.center.x = view.center.x
        img.frame.origin.y = (header?.frame.minY ?? 0) + (146.0 * figmaToiOSVerticalScalingFactor)
        view.addSubview(img)

        let imgToLargeTextGap = 40.0 * figmaToiOSVerticalScalingFactor
        largeText.draw(parentVC: self, centerX: view.center.x, originY: img.frame.maxY + imgToLargeTextGap)

        mainText.draw(parentVC: self, centerX: view.center.x, originY: largeText.frame.maxY)

        self.buttonRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.nextScreen))
        if let buttonRecognizer = self.buttonRecognizer {
            self.button.addGestureRecognizer(buttonRecognizer)
        }

        let buttonTop: CGFloat = 668.0 * figmaToiOSVerticalScalingFactor
        button.draw(parentVC: self, centerX: view.center.x, originY: buttonTop)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
