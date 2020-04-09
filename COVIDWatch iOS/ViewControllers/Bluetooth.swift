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
    var largeText = LargeText(text: "Quickly Connect")
    var mainText = MainText(text: "Covid Watch uses bluetooth to anonymously log interactions with other Covid Watch users that you come in contact with.")
    var button = Button(text: "Allow Bluetooth", subtext: "This is required for the app to work.")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: "FFFFFF")

        img.frame.size.width = screenWidth * 0.832
        img.frame.size.height = img.frame.size.width / (312.0/326.0)
        img.center.x = view.center.x
        img.center.y = header.frame.minY + (282.0 * figmaToiOSVerticalScalingFactor)
        view.addSubview(img)

        largeText.draw(parentVC: self, centerX: view.center.x, centerY: header.frame.minY + (512.0 * figmaToiOSVerticalScalingFactor))

        mainText.draw(parentVC: self, centerX: view.center.x, originY: header.frame.minY + (546.0 * figmaToiOSVerticalScalingFactor))

        self.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextScreen)))
        button.draw(parentVC: self, centerX: view.center.x, centerY: screenHeight - (114.0 * figmaToiOSVerticalScalingFactor))
    }

    @objc func nextScreen(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if UserDefaults.standard.isContactEventLoggingEnabled == false {
                UserDefaults.standard.isContactEventLoggingEnabled = true

            }
            performSegue(withIdentifier: "BluetoothToNotifications", sender: self)
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
