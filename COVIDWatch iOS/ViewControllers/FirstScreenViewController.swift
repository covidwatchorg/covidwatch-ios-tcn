//
//  FirstScreen.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 3/30/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {

    @IBOutlet weak var firstScreenToOnboardingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firstScreenToOnboardingButton.layer.cornerRadius = 10
    }

    @IBAction func firstScreenToOnboardingButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "FirstScreenToOnboarding", sender: self)
    }
}
