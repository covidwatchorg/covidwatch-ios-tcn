//
//  Bluetooth.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Finish: BaseViewController {
    var img = UIImageView(image: UIImage(named: "woman-hero-blue-3"))
    var largeText = LargeText(text: "You're all set!")
    var mainText = MainText(text: "Thank you for helping protect your communities. You will be notified of potential contact with COVID-19.")
    var button = Button(text: "Finish", subtext: nil)
    var backgroundGradient = UIView()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        backgroundGradient.frame.size.width = screenWidth
        backgroundGradient.frame.size.height = screenHeight - header.frame.maxY
        backgroundGradient.frame.origin.y = header.frame.maxY
        backgroundGradient.layer.contents = UIImage(named: "background-gradient-blue")?.cgImage
        self.view.addSubview(backgroundGradient)
        view.addSubview(img)

        img.frame.size.width = 251 * figmaToiOSHorizontalScalingFactor
        img.frame.size.height = 308 * figmaToiOSVerticalScalingFactor
        
        img.frame.origin.x = -15.0 * figmaToiOSHorizontalScalingFactor
        if screenHeight <= 667 {
            img.frame.size.width /= 1.5
            img.frame.size.height /= 1.5
            img.center.x = view.center.x - 0.5 * view.center.x
        }
        img.frame.origin.y = header.frame.maxY + (59 * figmaToiOSVerticalScalingFactor)

        largeText.draw(parentVC: self, centerX: view.center.x, originY: img.frame.maxY + (33.0 * figmaToiOSVerticalScalingFactor))
        largeText.textColor = .white

        mainText.textColor = .white
        mainText.draw(parentVC: self, centerX: view.center.x, originY: largeText.frame.maxY)
        self.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextScreen)))
        let buttonTop: CGFloat = 668.0 * figmaToiOSVerticalScalingFactor
        button.draw(parentVC: self, centerX: view.center.x, originY: buttonTop)
        button.text.textColor = UIColor(hexString: "585858")
        button.backgroundColor = .white
    }

    @objc func nextScreen(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            performSegue(withIdentifier: "FinishToHome", sender: self)
        }
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        img.frame.size.width = screenWidth * 0.832
//        img.frame.size.height = img.frame.size.width / (312.0/326.0)
//        img.center.x = view.center.x
//        print(header.frame.maxY)
//        img.frame.origin.y = header.frame.maxY + (22 * figmaToiOSVerticalScalingFactor)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
