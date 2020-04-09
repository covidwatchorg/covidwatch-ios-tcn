//
//  Bluetooth.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Finish: BaseViewController {
    var img = UIImageView(image: UIImage(named: "people-group-blue-2"))
    var largeText = LargeText()
    var mainText = MainText()
    var button = Button(text: "Finish", subtext: nil)
    var backgroundGradient = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
//            Layout image first and then layout background gradient compared to it

        img.frame.size.width = screenWidth * 0.832
        img.frame.size.height = img.frame.size.width / (312.0/326.0)
        img.center.x = view.center.x
        img.center.y = header.frame.minY + (282.0/812.0) * screenHeight

        backgroundGradient.frame.size.width = screenWidth
        backgroundGradient.frame.size.height = screenHeight + 40
        backgroundGradient.frame.origin.y = img.frame.minY
        backgroundGradient.layer.contents = UIImage(named: "background-gradient-blue")?.cgImage
        self.view.addSubview(backgroundGradient)
        view.addSubview(img)

        largeText.text = "You're all set!"
        largeText.frame.size.height = largeText.contentSize.height
        largeText.frame.origin.y = header.frame.minY + (481.0/812.0) * screenHeight
        largeText.center.x = view.center.x
        largeText.backgroundColor = .clear
        largeText.textColor = .white
        view.addSubview(largeText)

        mainText.text = "Thank you for helping protect your communities. You will be notified of potential contact with COVID-19."
        mainText.frame.size.height = mainText.contentSize.height
        mainText.frame.origin.y = header.frame.minY + (546.0/812.0) * screenHeight
        mainText.center.x = view.center.x
        mainText.backgroundColor = .clear
        mainText.textColor = .white
        view.addSubview(mainText)

        button.center.x = view.center.x
        button.frame.origin.y = screenHeight - (144.0/812.0) * screenHeight
        button.text.textColor = UIColor(hexString: "585858")
        button.backgroundColor = .white
        self.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextScreen)))
        button.draw(parentVC: self)
    }

    @objc func nextScreen(sender : UITapGestureRecognizer) {
        if sender.state == .ended {
            performSegue(withIdentifier: "FinishToHome", sender: self)
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
