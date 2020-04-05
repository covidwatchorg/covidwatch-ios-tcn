//
//  Bluetooth.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//


import UIKit

class Home: UIViewController {
    let screenSize: CGRect = UIScreen.main.bounds
    var appTitle = UILabel()
    var icon: UIImageView?
    var parkImage: UIImageView?
    var mainText = UITextView()
    var spreadTheWordButton = UIView()
    var spreadTheWordLabel = UILabel()
    var spreadTheWordDescription = UITextView()
    var testedButton = UIView()
    var testedLabel = UILabel()
    var testedDescription = UITextView()
    var isCurrentUserSickObserver: NSKeyValueObservation?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        isCurrentUserSickObserver = UserDefaults.standard.observe(\.isCurrentUserSick, options: [.initial, .new], changeHandler: { (_,_) in
//            self.view.backgroundColor = UserDefaults.standard.isCurrentUserSick ? .systemRed : .systemGreen
//        })
//        UserDefaults.standard.isCurrentUserSick = true
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let scalingFactor = CGFloat(screenHeight) / CGFloat(896)
        var fontScalingFactor = CGFloat(1.0)
        if screenHeight <= 736.0 { fontScalingFactor = scalingFactor }
        print("ScreenHeight = \(screenHeight)")
        
        self.view.backgroundColor = UIColor(hexString: "FFFFFF")

        icon = UIImageView(image: UIImage(named: "logo-cw-color"))
        icon!.frame.size.width = 41
        icon!.frame.size.height = 39
        icon!.center.x = view.center.x
        icon!.center.y = 100
        if screenHeight <= 736.0 { icon!.center.y *= scalingFactor }
        self.view.addSubview(icon!)
        appTitle.text =  "COVID WATCH"
        appTitle.textColor = UIColor(hexString: "F05452")
        appTitle.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        appTitle.sizeToFit()
        appTitle.center.x = view.center.x
        appTitle.center.y = icon!.center.y + icon!.frame.size.height/2 + 15
        self.view.addSubview(appTitle)
        
        parkImage = UIImageView(image: UIImage(named: "sp-people-in-park-colorized-3"))
        parkImage!.frame.size.width = screenWidth
        parkImage!.center.x = view.center.x
        parkImage!.center.y = appTitle.center.y + parkImage!.image!.size.height/2 + (scalingFactor * 40 )
        view.addSubview(parkImage!)
        
        mainText.text =  "Covid Watch is using bluetooth to anonymously watch who you come in contact with. You will be notified of potential contact to COVID-19.\n\nThank you for helping your community stay safe, anonymously."
        mainText.textColor = UIColor(hexString: "585858")
        mainText.font = UIFont(name: "Montserrat-Regular", size: 18 * fontScalingFactor)
        mainText.frame.size.width = 330
        mainText.frame.size.height = mainText.contentSize.height
        mainText.isEditable = false
        mainText.backgroundColor = .clear
        mainText.center.x = view.center.x
        mainText.center.y = parkImage!.center.y + (parkImage!.image!.size.height / 2) + (mainText.frame.size.height / 2)
        view.addSubview(mainText)
        
        spreadTheWordButton.frame.size.width = mainText.frame.size.width
        spreadTheWordButton.frame.size.height = 60
        spreadTheWordButton.center.x = view.center.x
        spreadTheWordButton.center.y = mainText.center.y + mainText.frame.size.height/2 + (scalingFactor * 60)
        spreadTheWordButton.backgroundColor = UIColor(hexString: "496FB6")
        spreadTheWordButton.layer.cornerRadius = 10
        view.addSubview(spreadTheWordButton)

        spreadTheWordLabel.text =  "Spread the word"
        spreadTheWordLabel.textColor = .white
        spreadTheWordLabel.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        spreadTheWordLabel.sizeToFit()
        spreadTheWordLabel.center = spreadTheWordButton.center
        view.addSubview(spreadTheWordLabel)
        
        spreadTheWordDescription.text =  "It works best when everyone uses it."
        spreadTheWordDescription.textColor = UIColor(hexString: "585858")
        spreadTheWordDescription.font = UIFont(name: "Montserrat-Regular", size: 14)
        spreadTheWordDescription.sizeToFit()
        spreadTheWordDescription.isEditable = false
        spreadTheWordDescription.backgroundColor = .clear
        spreadTheWordDescription.center.x = view.center.x
        spreadTheWordDescription.center.y = spreadTheWordButton.center.y + spreadTheWordButton.frame.size.height/2 + (scalingFactor * 20)
        view.addSubview(spreadTheWordDescription)
        
        testedButton.frame.size.width = mainText.frame.size.width
        testedButton.frame.size.height = 60
        testedButton.center.x = view.center.x
        testedButton.center.y = spreadTheWordDescription.center.y + (spreadTheWordDescription.frame.size.height/2) + (scalingFactor * 40)
        testedButton.backgroundColor = UIColor(hexString: "ECF2FA")
        testedButton.layer.cornerRadius = 10
        view.addSubview(testedButton)

        testedLabel.text =  "Tested for COVID-19?"
        testedLabel.textColor = UIColor(hexString: "585858")
        testedLabel.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        testedLabel.sizeToFit()
        testedLabel.center = testedButton.center
        view.addSubview(testedLabel)
        
        testedDescription.text =  "Share the result anonymously to help your community stay safe"
        testedDescription.textColor = UIColor(hexString: "585858")
        testedDescription.font = UIFont(name: "Montserrat-Regular", size: 14)
        testedDescription.textAlignment = .center
        testedDescription.frame.size.width = testedButton.frame.size.width
        testedDescription.frame.size.height = testedDescription.contentSize.height
        testedDescription.isEditable = false
        testedDescription.backgroundColor = .clear
        testedDescription.center.x = view.center.x
        testedDescription.center.y = testedButton.center.y + testedButton.frame.size.height/2 + (scalingFactor * 25)
        view.addSubview(testedDescription)
        
        
        

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
