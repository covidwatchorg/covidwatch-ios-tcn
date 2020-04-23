//
//  Entry.swift
//  CovidWatch iOS
//
//  Created by Nikhil Kumar on 4/12/20.
//  
//

import UIKit

class Entry: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainGradient = CAGradientLayer()
        mainGradient.colors = [UIColor.Primary.Aqua.cgColor, UIColor.Primary.Bluejay.cgColor]
        mainGradient.locations = [0.0, 1.0]
        mainGradient.frame = view.frame
        view.layer.insertSublayer(mainGradient, at: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserDefaults.shared.isFirstTimeUser {
            performSegue(withIdentifier: "goToOnboarding", sender: self)
        } else {
            performSegue(withIdentifier: "goToHome", sender: self)
        }
    }
}
