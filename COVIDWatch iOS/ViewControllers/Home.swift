//
//  share.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/8/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

// This should become a global user state
struct UserState {
    var firstTimeUser: Bool
    var hasBeenInContact: Bool
    var hasBeenTestedInLast14Days: Bool
}

class Home: BaseViewController {
    var img = UIImageView(image: UIImage(named: "woman-hero-blue-2"))
    var largeText = LargeText(text: "You're all set!")
    //swiftlint:disable:next line_length
    var mainText = MainText(text: "Thank you for helping protect your communities. You will be notified of potential contact with COVID-19.")
    var spreadButton = Button(text: "Spread the word", subtext: "It works best when everyone uses it.")
    var testedButton = Button(text: "Tested for COVID-19?",
                              subtext: "Share your result anonymously to help keep your community stay safe.")
    var infoBanner = InfoBanner(text: "You may have been in contact with COVID-19")
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        for testing purposes only; user state should be stored and managed globally
        let userState = UserState(firstTimeUser: true, hasBeenInContact: false, hasBeenTestedInLast14Days: false)
        drawScreen(userState: userState)
    }
    @objc func test() {
         performSegue(withIdentifier: "test", sender: self)
    }
    // swiftlint:disable:next function_body_length
    private func drawScreen(userState: UserState) {
//        optionally draw the info banner and determine the coordinate for the top of the image
        var imgTop: CGFloat
        if userState.hasBeenInContact {
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

        var mainTextTop: CGFloat
        if userState.firstTimeUser {
            largeText.text = "You're all set!"
            largeText.draw(parentVC: self,
            centerX: view.center.x,
            originY: img.frame.maxY + (22.0 * figmaToiOSVerticalScalingFactor))
            mainTextTop = largeText.frame.maxY
        } else if !userState.hasBeenInContact {
            largeText.text = "Welcome Back!"
            largeText.draw(parentVC: self,
            centerX: view.center.x,
            originY: img.frame.maxY + (22.0 * figmaToiOSVerticalScalingFactor))
            mainTextTop = largeText.frame.maxY
        } else {
//            userState.hasBeenInContact
            mainTextTop = img.frame.maxY + 25.0 * figmaToiOSVerticalScalingFactor
        }

//        draw mainText with respect to largeText or img or not at all
        if userState.firstTimeUser {
            // swiftlint:disable:next line_length
            mainText.text = "Thank you for helping protect your communities. You will be notified of potential contact with COVID-19."
            mainText.draw(parentVC: self, centerX: view.center.x, originY: mainTextTop)
        } else if !userState.hasBeenInContact {
            // swiftlint:disable:next line_length
            mainText.text = "Covid Watch has not detected exposure to COVID-19. Share the app with family and friends to help your community stay safe."
            mainText.draw(parentVC: self, centerX: view.center.x, originY: mainTextTop)
        } else {
//            userState.hasBeenInContact
            mainText.text = "Thank you for helping your community stay safe, anonymously."
            mainText.draw(parentVC: self, centerX: view.center.x, originY: mainTextTop)
            mainText.textAlignment = .center
        }

        if userState.hasBeenInContact || screenHeight <= 568 {
//            Necessary to fit on screen
            spreadButton.subtext = nil
        }
//        spreadButton drawn below because its position depends on whether testedButton is drawn

        if !userState.hasBeenTestedInLast14Days {
            self.testedButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.test)))
            let testedButtonTop: CGFloat = 668.0 * figmaToiOSVerticalScalingFactor
            testedButton.draw(parentVC: self, centerX: view.center.x, originY: testedButtonTop)
            testedButton.backgroundColor = .clear
            testedButton.layer.borderWidth = 1
            testedButton.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
            testedButton.text.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
            spreadButton.drawBetween(parentVC: self,
                                     top: mainText.frame.maxY,
                                     bottom: testedButtonTop,
                                     centerX: view.center.x)
        } else {
            spreadButton.drawBetween(parentVC: self,
                                     top: mainText.frame.maxY,
                                     bottom: screenHeight - self.view.safeAreaInsets.bottom,
                                     centerX: view.center.x)
        }

    }

}
