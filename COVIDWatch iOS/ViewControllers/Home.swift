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
    var warningBanner = UIView()
    var warningLabel = UITextView()
    var isUserSickObserver: NSKeyValueObservation?
    var didUserMakeContactWithSickUserObserver: NSKeyValueObservation?
    let mainText1 = "Covid Watch is using bluetooth to anonymously watch who you come in contact with. You will be notified of potential contact to COVID-19.\n\n"
    let mainText2 = "Thank you for helping your community stay safe, anonymously."
    var scalingFactor: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scalingFactor = CGFloat(screenHeight) / CGFloat(896)
        var fontScalingFactor = CGFloat(1.0)
        if screenHeight <= 736.0 { fontScalingFactor = scalingFactor! }
        print("ScreenHeight = \(screenHeight)")

        self.view.backgroundColor = UIColor(hexString: "FFFFFF")

        icon = UIImageView(image: UIImage(named: "logo-cw-color"))
        icon!.frame.size.width = 41
        icon!.frame.size.height = 39
        icon!.center.x = view.center.x
        icon!.center.y = 100
        if screenHeight <= 736.0 { icon!.center.y *= scalingFactor! }
        self.view.addSubview(icon!)
        appTitle.text =  "COVID WATCH"
        appTitle.textColor = UIColor(hexString: "F05452")
        appTitle.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        appTitle.sizeToFit()
        appTitle.center.x = view.center.x
        appTitle.center.y = icon!.center.y + icon!.frame.size.height/2 + 15
        self.view.addSubview(appTitle)

        warningBanner.frame.size.width = screenWidth
        warningBanner.backgroundColor = UIColor(hexString: "F05452")
        warningBanner.center.x = view.center.x
        self.view.addSubview(warningBanner)

        warningLabel.textColor = .white
        warningLabel.backgroundColor = .clear
        warningLabel.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        warningLabel.frame.size.width = 330
        self.view.addSubview(warningLabel)

        parkImage = UIImageView(image: UIImage(named: "sp-people-in-park-colorized-3"))
        parkImage!.frame.size.width = screenWidth
        parkImage!.center.x = view.center.x
        view.addSubview(parkImage!)

        mainText.textColor = UIColor(hexString: "585858")
        mainText.font = UIFont(name: "Montserrat-Regular", size: 18 * fontScalingFactor)
        mainText.frame.size.width = 330
        mainText.text = mainText1 + mainText2
        mainText.isEditable = false
        mainText.backgroundColor = .clear
        mainText.center.x = view.center.x
        view.addSubview(mainText)

        spreadTheWordButton.frame.size.width = mainText.frame.size.width
        spreadTheWordButton.center.x = view.center.x
        spreadTheWordButton.backgroundColor = UIColor(hexString: "496FB6")
        spreadTheWordButton.layer.cornerRadius = 10
        view.addSubview(spreadTheWordButton)

        spreadTheWordLabel.text =  "Spread the word"
        spreadTheWordLabel.textColor = .white
        spreadTheWordLabel.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        view.addSubview(spreadTheWordLabel)

        spreadTheWordDescription.text =  "It works best when everyone uses it."
        spreadTheWordDescription.textColor = UIColor(hexString: "585858")
        spreadTheWordDescription.font = UIFont(name: "Montserrat-Regular", size: 14)
        spreadTheWordDescription.isEditable = false
        spreadTheWordDescription.backgroundColor = .clear
        spreadTheWordDescription.sizeToFit()
        spreadTheWordDescription.center.x = spreadTheWordButton.center.x
        view.addSubview(spreadTheWordDescription)

        testedButton.frame.size.width = mainText.frame.size.width
        testedButton.backgroundColor = UIColor(hexString: "ECF2FA")
        testedButton.layer.cornerRadius = 10
        testedButton.center.x = view.center.x
        view.addSubview(testedButton)

        testedLabel.text =  "Tested for COVID-19?"
        testedLabel.textColor = UIColor(hexString: "585858")
        testedLabel.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        view.addSubview(testedLabel)

        testedDescription.text =  "Share the result anonymously to help your community stay safe"
        testedDescription.textColor = UIColor(hexString: "585858")
        testedDescription.font = UIFont(name: "Montserrat-Regular", size: 14)
        testedDescription.textAlignment = .center
        testedDescription.frame.size.width = testedButton.frame.size.width
        testedDescription.isEditable = false
        testedDescription.backgroundColor = .clear
        testedDescription.center.x = view.center.x
        view.addSubview(testedDescription)

        print(UserDefaults.standard.isUserSick)
        print(UserDefaults.standard.didUserMakeContactWithSickUser)

        //        Change interface based on whether user is sick or made contact
        self.manageGlobalState(UserDefaults.standard.isUserSick, UserDefaults.standard.didUserMakeContactWithSickUser)

        //        Set up observers to update based on state changes
        isUserSickObserver = UserDefaults.standard.observe(\.isUserSick, options: [.new], changeHandler: { (_, change) in
            if (change.newValue == nil) {
                return
            }
            self.manageGlobalState(change.newValue!, UserDefaults.standard.didUserMakeContactWithSickUser)
        })
        didUserMakeContactWithSickUserObserver = UserDefaults.standard.observe(\.didUserMakeContactWithSickUser, options: [.initial, .new], changeHandler: { (_, change) in
            if (change.newValue == nil) {
                return
            }
            self.manageGlobalState(UserDefaults.standard.isUserSick, change.newValue!)
        })
    }

    @objc func nextScreen(sender : UITapGestureRecognizer) {
        if sender.state == .ended {
            performSegue(withIdentifier: "NotificationsToFinish", sender: self)
        }
    }

    private func updateHeightsAndYPositions(_ warningBannerVisible: Bool) {
        warningBanner.frame.size.height = 60 * 1.5 * scalingFactor!
        warningBanner.center.y = appTitle.center.y + warningBanner.frame.size.height/2 + (self.scalingFactor! * 40)

        warningLabel.frame.size.height = warningLabel.contentSize.height
        warningLabel.center = warningBanner.center

        if (warningBannerVisible) {
            parkImage!.center.y = warningBanner.center.y + warningBanner.frame.size.height/2 + parkImage!.image!.size.height/2
        } else {
            parkImage!.center.y = appTitle.center.y + parkImage!.image!.size.height/2 + (self.scalingFactor! * 40 )
        }

        mainText.frame.size.height = mainText.contentSize.height
        mainText.center.y = parkImage!.center.y + (parkImage!.image!.size.height / 2) + (mainText.frame.size.height / 2)

        spreadTheWordButton.frame.size.height = 60
        spreadTheWordButton.center.y = mainText.center.y + mainText.frame.size.height/2 + (scalingFactor! * 60)

        spreadTheWordLabel.sizeToFit()
        spreadTheWordLabel.center = spreadTheWordButton.center


        spreadTheWordDescription.center.y = spreadTheWordButton.center.y + spreadTheWordButton.frame.size.height/2 + (scalingFactor! * 20)

        testedButton.frame.size.height = 60
        testedButton.center.y = spreadTheWordDescription.center.y + (spreadTheWordDescription.frame.size.height/2) + (scalingFactor! * 40)

        testedLabel.sizeToFit()
        testedLabel.center = testedButton.center

        testedDescription.frame.size.height = testedDescription.contentSize.height
        testedDescription.center.y = testedButton.center.y + testedButton.frame.size.height/2 + (scalingFactor! * 25)
    }

    //    Decides what to display based on global app state
    private func manageGlobalState(_ isUserSick: Bool, _ didUserMakeContactWithSickUser: Bool) {
        if (isUserSick || didUserMakeContactWithSickUser) {
            warningBanner.isHidden = false
            warningLabel.isHidden = false

            mainText.text = mainText2
            if isUserSick {
                warningLabel.text = "You reported that you tested positive for COVID-19"
                testedButton.isHidden = true
                testedLabel.isHidden = true
                testedDescription.isHidden = true
            } else {
                warningLabel.text = "You may have been in contact with COVID-19"
                testedButton.isHidden = false
                testedLabel.isHidden = false
                testedDescription.isHidden = false
            }
        } else {
            warningBanner.isHidden = true
            warningLabel.isHidden = true
            mainText.text = mainText1 + mainText2
            testedButton.isHidden = false
            testedLabel.isHidden = false
            testedDescription.isHidden = false
        }
        self.updateHeightsAndYPositions(isUserSick || didUserMakeContactWithSickUser)

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
