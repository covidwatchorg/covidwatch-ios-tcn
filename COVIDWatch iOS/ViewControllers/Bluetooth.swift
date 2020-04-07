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
    var largeText = LargeText()
    var mainText = MainText()
    var button = Button(text: "Allow Bluetooth", subtext: "This is required for the app to work.")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: "FFFFFF")
        
        img.frame.size.width = screenSize.width * 0.832
        img.frame.size.height = img.frame.size.width / (312.0/326.0)
        img.center.x = view.center.x
        img.center.y = header.frame.minY + (282.0/812.0) * screenSize.height
        view.addSubview(img)
        
        largeText.text = "Quickly Connect"
        largeText.frame.size.height = largeText.contentSize.height
        largeText.frame.origin.y = header.frame.minY + (481.0/812.0) * screenSize.height
        largeText.center.x = view.center.x
        view.addSubview(largeText)
        
        mainText.text = "Covid Watch uses bluetooth to anonymously log interactions with other Covid Watch users that you come in contact with."
        mainText.frame.size.height = mainText.contentSize.height
        mainText.frame.origin.y = header.frame.minY + (546.0/812.0) * screenSize.height
        mainText.center.x = view.center.x
        view.addSubview(mainText)
        
        button.center.x = view.center.x
        button.frame.origin.y = screenSize.height - (144.0/812.0) * screenSize.height
        self.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextScreen)))
        button.draw(parentVC: self)
    }
        
    @objc func nextScreen(sender : UITapGestureRecognizer) {
        if sender.state == .ended {
            if UserDefaults.standard.isContactEventLoggingEnabled == false {
                UserDefaults.standard.isContactEventLoggingEnabled = true
                
            }
            performSegue(withIdentifier: "BluetoothToNotifications", sender: self)
        }
    }

    /*
    // MARK: - Navigation
​
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
