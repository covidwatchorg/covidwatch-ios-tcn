//
//  OnboardingViewController.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 3/30/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var onboardingToTabBarButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        onboardingToTabBarButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func onboardingToTabBarButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "OnboardingToTabBar", sender: self)
    }
}
