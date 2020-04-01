//
//  HomeViewController.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 3/31/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var statusImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.isContactEventLoggingEnabled == false {
            UserDefaults.standard.isContactEventLoggingEnabled = true
        }
        statusImage.image = #imageLiteral(resourceName: "EverlyAndInstructions")
    }
}
