//
//  Bluetooth.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//


import UIKit

class Notifications: UIViewController {
    let screenSize: CGRect = UIScreen.main.bounds
    var appTitle = UILabel()
    var icon: UIImageView?
    var parkImage: UIImageView?
    var description1 = UITextView()
    var allowNotificationsButton = UIView()
    var allowNotificationsLabel = UILabel()
    var description2 = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let scalingFactor = CGFloat(screenHeight) / CGFloat(896)
        
        self.view.backgroundColor = UIColor(hexString: "FFFFFF")

        icon = UIImageView(image: UIImage(named: "logo-cw-color"))
        icon!.frame.size.width = 41
        icon!.frame.size.height = 39
        icon!.center.x = view.center.x
        icon!.center.y = (scalingFactor/1.5) * 100
        self.view.addSubview(icon!)
        appTitle.text =  "COVID WATCH"
        appTitle.textColor = UIColor(hexString: "F05452")
        appTitle.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        appTitle.sizeToFit()
        appTitle.center.x = view.center.x
        appTitle.center.y = icon!.center.y + icon!.frame.size.height/2 + (15)
        self.view.addSubview(appTitle)
        
        parkImage = UIImageView(image: UIImage(named: "sp-people-in-park-colorized-1"))
        parkImage!.frame.size.width = screenWidth
        parkImage!.center.x = view.center.x
        parkImage!.center.y = appTitle.center.y + parkImage!.image!.size.height/2 + (scalingFactor * 40)
        view.addSubview(parkImage!)
        
        description1.text =  "Covid Watch uses notifications to warn you of potential contact to COVID-19."
        description1.textColor = UIColor(hexString: "585858")
        description1.font = UIFont(name: "Montserrat-Regular", size: 18)
        description1.frame.size.width = 330
        description1.frame.size.height = 75
        description1.isEditable = false
        description1.backgroundColor = .clear
        description1.center.x = view.center.x
        description1.center.y = parkImage!.center.y + parkImage!.image!.size.height/2 + (scalingFactor * 40)
        view.addSubview(description1)
        
        allowNotificationsButton.frame.size.width = description1.frame.size.width
        allowNotificationsButton.frame.size.height = 60
        allowNotificationsButton.center.x = view.center.x
        allowNotificationsButton.center.y = description1.center.y + description1.frame.size.height/2 + (scalingFactor * 60)
        allowNotificationsButton.backgroundColor = UIColor(hexString: "496FB6")
        allowNotificationsButton.layer.cornerRadius = 10
        self.allowNotificationsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextScreen)))
        view.addSubview(allowNotificationsButton)

        allowNotificationsLabel.text =  "Allow Notifications"
        allowNotificationsLabel.textColor = .white
        allowNotificationsLabel.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        allowNotificationsLabel.sizeToFit()
        allowNotificationsLabel.center = allowNotificationsButton.center
        view.addSubview(allowNotificationsLabel)
        
        description2.text =  "This will help you find out when you are at risk."
        description2.textColor = UIColor(hexString: "585858")
        description2.font = UIFont(name: "Montserrat-Regular", size: 14)
        description2.sizeToFit()
        description2.isEditable = false
        description2.backgroundColor = .clear
        description2.center.x = view.center.x
        description2.center.y = allowNotificationsButton.center.y + allowNotificationsButton.frame.size.height/2 + (scalingFactor * 20)
        view.addSubview(description2)
        
        

    }
        
    @objc func nextScreen(sender : UITapGestureRecognizer) {
        if sender.state == .ended {
            performSegue(withIdentifier: "NotificationsToFinish", sender: self)
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
