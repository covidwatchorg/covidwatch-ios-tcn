//
//  FirstScreen.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 3/30/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getStartedPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "FirstScreenToOnboarding", sender: self)
    }
}

