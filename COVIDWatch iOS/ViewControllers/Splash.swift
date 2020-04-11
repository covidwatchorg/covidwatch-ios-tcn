//
//  Splash-4.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Splash: UIViewController {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var superheroImage: UIImageView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // background gradient
        self.view.backgroundColor = UIColor.clear
        let colorTop = UIColor(red: 67.0 / 255.0, green: 196.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 44.0 / 255.0, green: 88.0 / 255.0, blue: 177.0 / 255.0, alpha: 1.0).cgColor

        let mainGradient = CAGradientLayer()
        mainGradient.colors = [colorTop, colorBottom]
        mainGradient.locations = [0.0, 1.0]
        mainGradient.frame = view.frame
        view.layer.insertSublayer(mainGradient, at: 0)

        iconImage.image = UIImage(named: "logo-cw-white")

        titleText.text =  "COVID WATCH"
        titleText.textColor = .white
        titleText.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        titleText.sizeToFit()

        superheroImage.image = UIImage(named: "family-superhero")

        // description text
        descriptionText.text = "Help your community stay safe, anonymously."
        descriptionText.textColor = .white
        descriptionText.font = UIFont(name: "Montserrat-Medium", size: 22)
        descriptionText.textAlignment = .center
        descriptionText.backgroundColor = .clear

        startButton.layer.cornerRadius = 10
        startButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 24)

    }

    @objc func nextScreen(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            performSegue(withIdentifier: "SplashToBluetooth", sender: self)
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
