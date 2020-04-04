//
//  HomeViewController.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 3/31/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.layer.cornerRadius = 10
//        performSegue(withIdentifier: "NoContactToContact", sender: self)

        if UserDefaults.standard.isContactEventLoggingEnabled == false {
            UserDefaults.standard.isContactEventLoggingEnabled = true
            
        }
    }
}
