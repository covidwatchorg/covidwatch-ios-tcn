//
//  share.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/8/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Home: BaseViewController {
    var img = UIImageView(image: UIImage(named: "woman-hero-blue-2"))
    var largeText = LargeText(text: "You're all set!")
    //swiftlint:disable:next line_length
    var mainText = MainText(text: "Thank you for helping protect your communities. You will be notified of potential contact with COVID-19.")
    var spreadButton = Button(text: "Share the app", subtext: "It works best when everyone uses it.")
    var testedButton = Button(text: "Tested for COVID-19?",
                              subtext: "Share your result anonymously to help keep your community stay safe.")
    var infoBanner = InfoBanner(text: "You may have been in contact with COVID-19")
    var lastTestedDateObserver: NSKeyValueObservation?
    var didUserMakeContactWithSickUserObserver: NSKeyValueObservation?
    var observer: NSObjectProtocol?
    var bluetoothPermission: BluetoothPermission?

    override func viewDidLoad() {
        super.viewDidLoad()
        lastTestedDateObserver = UserDefaults.shared.observe(
            \.lastTestedDate,
            options: [.initial, .new],
            changeHandler: { (_, _) in
            self.drawScreen()
        })

        didUserMakeContactWithSickUserObserver = UserDefaults.shared.observe(
            \.didUserMakeContactWithSickUser,
            options: [],
            changeHandler: { (_, _) in
            self.drawScreen()
        })

        self.observer = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil, queue: OperationQueue.main
        ) { [weak self] _ in
            self?.checkNotificationPersmission()
        }
        self.checkNotificationPersmission()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawScreen()
    }

    @objc func test() {
        self.performSegue(withIdentifier: "test", sender: self)
    }

    // bluetooth and notification permissions
    enum AuthorizedPermissions {
        case bluetooth
        case notifications
    }

    func checkNotificationPersmission(_ requiredPermissions: [AuthorizedPermissions] = []) {
        var morePermissions = requiredPermissions
        _ = NotificationPermission { [weak self] (result) in
            switch result {
            case .success:
                self?.checkBluetoothPermission(morePermissions)
            case .failure(let error):
                morePermissions.append(.notifications)
                self?.checkBluetoothPermission(morePermissions)
                print("Please go insto settings and enable Notifications", error)
            }
        }
    }

    func checkBluetoothPermission(_ requiredPermissions: [AuthorizedPermissions] = []) {
        self.bluetoothPermission = BluetoothPermission { [weak self] (result) in
            var morePermissions = requiredPermissions
            switch result {
            case .success:
                // nothing to do
                print("Bluetooth is still enabled")
                self?.showPermissionsAlert(morePermissions)
            case .failure:
                morePermissions.append(.bluetooth)
                self?.showPermissionsAlert(morePermissions)
            }
        }
    }

    func showPermissionsAlert(_ requiredPermissions: [AuthorizedPermissions] = []) {
        if requiredPermissions.count > 0 {
            var permissionTitle = "Permission Required"
            var permissionText = "Bluetooth and Notifications"
            if requiredPermissions.count == 1 {
                for permission in requiredPermissions {
                    switch permission {
                    case .bluetooth:
                        permissionTitle = "Bluetooth Required"
                        permissionText = "Bluetooth"
                    case .notifications:
                        permissionTitle = "Notifications Required"
                        permissionText = "Notifications"
                    }
                }
            }

            let permissionsAlert = UIAlertController(
                title: NSLocalizedString(permissionTitle, comment: ""),
                message: "Please turn on \(permissionText) in Settings", preferredStyle: .alert
            )
            permissionsAlert.addAction(
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
            self.present(permissionsAlert, animated: true)
        }
    }

    @objc func share() {
        // text to share
        let text = "Become a COVID Watcher and help your community stay safe."
        let url = NSURL(string: "https://www.covid-watch.org")

        // set up activity view controller
        let itemsToShare: [Any] = [ text, url as Any ]
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)

        // so that iPads won't crash
        activityViewController.popoverPresentationController?.sourceView = self.view

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    // swiftlint:disable:next function_body_length
    private func drawScreen() {
//        optionally draw the info banner and determine the coordinate for the top of the image
        var imgTop: CGFloat
        if UserDefaults.shared.didUserMakeContactWithSickUser {
            infoBanner.isHidden = false
            infoBanner.draw(parentVC: self, centerX: view.center.x, originY: header.frame.maxY)
            imgTop = infoBanner.frame.maxY + 21.0 * figmaToiOSVerticalScalingFactor
        } else {
            infoBanner.isHidden = true
            imgTop = header.frame.maxY
        }
//        determine image size
        img.frame.size.width = 253 * figmaToiOSHorizontalScalingFactor
        img.frame.size.height = 259 * figmaToiOSVerticalScalingFactor
        if UserDefaults.shared.isFirstTimeUser && screenHeight <= 667 {
            img.frame.size.width /= 1.5
            img.frame.size.height /= 1.5
        }
        img.center.x = view.center.x - 5 * figmaToiOSHorizontalScalingFactor
        img.frame.origin.y = imgTop
        self.view.addSubview(img)

        var mainTextTop: CGFloat
        if UserDefaults.shared.isFirstTimeUser {
            largeText.isHidden = false
            largeText.text = "You're all set!"
            largeText.draw(parentVC: self,
            centerX: view.center.x,
            originY: img.frame.maxY + (22.0 * figmaToiOSVerticalScalingFactor))
            mainTextTop = largeText.frame.maxY
        } else if !UserDefaults.shared.didUserMakeContactWithSickUser {
            largeText.isHidden = false
            largeText.text = "Welcome Back!"
            largeText.draw(parentVC: self,
            centerX: view.center.x,
            originY: img.frame.maxY + (22.0 * figmaToiOSVerticalScalingFactor))
            mainTextTop = largeText.frame.maxY
        } else {
//            userState.hasBeenInContact
            largeText.isHidden = true
            mainTextTop = img.frame.maxY + 25.0 * figmaToiOSVerticalScalingFactor
        }

//        draw mainText with respect to largeText or img or not at all
        if UserDefaults.shared.isFirstTimeUser {
            // swiftlint:disable:next line_length
            mainText.text = "Thank you for helping protect your communities. You will be notified of potential contact with COVID-19."
            mainText.draw(parentVC: self, centerX: view.center.x, originY: mainTextTop)
        } else if !UserDefaults.shared.didUserMakeContactWithSickUser {
            // swiftlint:disable:next line_length
            mainText.text = "Covid Watch has not detected exposure to COVID-19. Share the app with family and friends to help your community stay safe."
            mainText.draw(parentVC: self, centerX: view.center.x, originY: mainTextTop)
        } else {
//            userState.hasBeenInContact
            mainText.text = "Thank you for helping your community stay safe, anonymously."
            mainText.draw(parentVC: self, centerX: view.center.x, originY: mainTextTop)
            mainText.textAlignment = .center
        }

        if UserDefaults.shared.didUserMakeContactWithSickUser || screenHeight <= 568 {
//            Necessary to fit on screen
            spreadButton.subtext?.removeFromSuperview()
            spreadButton.subtext = nil
        } else {
//            Clunky, but easier than messing with button internals
            spreadButton.text.removeFromSuperview()
            spreadButton.subtext?.removeFromSuperview()
            spreadButton.removeFromSuperview()
            spreadButton = Button(text: "Share the app", subtext: "It works best when everyone uses it.")
        }
//        spreadButton drawn below because its position depends on whether testedButton is drawn

        let calendar = Calendar.current

        var hasBeenTestedInLast14Days = false
        if let lastTestedDate = UserDefaults.shared.lastTestedDate {
            let date1 = calendar.startOfDay(for: lastTestedDate)
            let date2 = calendar.startOfDay(for: Date())

            let components = calendar.dateComponents([.day], from: date1, to: date2)
            if let numDays = components.day {
                hasBeenTestedInLast14Days = numDays <= 14 ? true : false
            }
        }
        spreadButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.share)))
        if !hasBeenTestedInLast14Days {
            self.testedButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.test)))
            let testedButtonTop: CGFloat = 668.0 * figmaToiOSVerticalScalingFactor
            testedButton.draw(parentVC: self, centerX: view.center.x, originY: testedButtonTop)
            testedButton.backgroundColor = .clear
            testedButton.layer.borderWidth = 1
            testedButton.layer.borderColor = UIColor.Secondary.LightGray.cgColor
            testedButton.text.textColor = UIColor.Primary.Gray
            spreadButton.drawBetween(parentVC: self,
                                     top: mainText.frame.maxY,
                                     bottom: testedButtonTop,
                                     centerX: view.center.x)
            testedButton.isHidden = false
            testedButton.text.isHidden = false
            testedButton.subtext?.isHidden = false
        } else {
            testedButton.isHidden = true
            testedButton.text.isHidden = true
            testedButton.subtext?.isHidden = true
            spreadButton.drawBetween(parentVC: self,
                                     top: mainText.frame.maxY,
                                     bottom: screenHeight - self.view.safeAreaInsets.bottom,
                                     centerX: view.center.x)
        }

        UserDefaults.shared.isFirstTimeUser = false

    }

}
