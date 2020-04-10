//
//  share.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/8/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit
enum TestedState {
    case notTested, testedPositive, testedNegative
}

struct UserState {
    var firstTimeUser: Bool
    var testedState: TestedState
    var hasBeenInContact: Bool
}

class Share: BaseViewController {
    var img = UIImageView(image: UIImage(named: "woman-hero-blue-2"))
    var largeText = LargeText(text: "Share & Protect")
    //swiftlint:disable:next line_length
    var mainText = MainText(text: "Covid Watch is using bluetooth to anonymously watch who you come in contact with. You will be notified of potential contact to COVID-19.")
    var spreadButton = Button(text: "Spread the word", subtext: "It works best when everyone uses it.")
    var testedButton = Button(text: "Tested for COVID-19?",
                              subtext: "Share your result anonymously to help keep your community stay safe.")
    var infoBanner = InfoBanner(text: "You may have been in contact with COVID-19")
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        TODO: for testing purposes only; user state should be stored and managed globally
        var userState = UserState(firstTimeUser: false, testedState: .notTested, hasBeenInContact: false)
        
        drawScreen(userState: userState)
    }
    @objc func test() {
         performSegue(withIdentifier: "test", sender: self)
    }
    
    private func drawScreen(userState: UserState) {
//        optionally draw the info banner and determine the coordinate for the top of the image
        var imgTop: CGFloat
        if !userState.firstTimeUser {
            infoBanner.draw(parentVC: self, centerX: view.center.x, originY: header.frame.maxY)
            imgTop = infoBanner.frame.maxY + 21.0 * figmaToiOSVerticalScalingFactor
        } else {
            imgTop = header.frame.maxY
        }
//        determine image size
        img.frame.size.width = 253 * figmaToiOSHorizontalScalingFactor
        img.frame.size.height = 259 * figmaToiOSVerticalScalingFactor
        if userState.firstTimeUser && screenHeight <= 667 {
            img.frame.size.width /= 1.5
            img.frame.size.height /= 1.5
        }
        img.center.x = view.center.x - 5 * figmaToiOSHorizontalScalingFactor
        img.frame.origin.y = imgTop
        self.view.addSubview(img)

//        draw "You're all set!" if first time user and determine mainText top
        var mainTextTop: CGFloat
        if userState.firstTimeUser {
            largeText.draw(parentVC: self,
            centerX: view.center.x,
            originY: img.frame.maxY + (22.0 * figmaToiOSVerticalScalingFactor))
            mainTextTop = largeText.frame.maxY
        } else {
            mainTextTop = img.frame.maxY + 25.0 * figmaToiOSVerticalScalingFactor
        }
//        draw mainText with respect to largeText or img or not at all, and determine spread button top
        var spreadButtonTop: CGFloat
        if userState.firstTimeUser {
            mainText.draw(parentVC: self, centerX: view.center.x, originY: mainTextTop)
            spreadButtonTop = mainText.frame.maxY + (5.0 * figmaToiOSVerticalScalingFactor)
        } else if userState.testedState != .notTested {
            mainText.text = "Thank you for helping your community stay safe, anonymously."
            mainText.textAlignment = .center
            mainText.draw(parentVC: self, centerX: view.center.x, originY: mainTextTop)
            spreadButtonTop = mainText.frame.maxY + (10.0 * figmaToiOSVerticalScalingFactor)
        } else {
            spreadButtonTop = img.frame.maxY + (30.0 * figmaToiOSVerticalScalingFactor)
        }


        spreadButton.draw(parentVC: self,
                          centerX: view.center.x,
                          originY: spreadButtonTop)

        if userState.testedState == .notTested {
            self.testedButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.test)))
            let testedButtonTop: CGFloat = 668.0 * figmaToiOSVerticalScalingFactor
            testedButton.draw(parentVC: self, centerX: view.center.x, originY: testedButtonTop)
            testedButton.backgroundColor = .clear
            testedButton.layer.borderWidth = 1
            testedButton.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
            testedButton.text.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        }
    }

}
