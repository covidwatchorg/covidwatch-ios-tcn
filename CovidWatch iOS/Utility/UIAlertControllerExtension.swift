//
//  UIAlertControllerExtension.swift
//  CovidWatch iOS
//
//  Created by Jeff Lett on 4/25/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

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
    
    static var notificationAlert: UIAlertController {
        let alert = UIAlertController(title: NSLocalizedString("Notifications Required", comment: ""),
                                      message: "Please turn on Notifications in Settings",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "", style: .default, handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(url)
        }))
        return alert
    }
}
