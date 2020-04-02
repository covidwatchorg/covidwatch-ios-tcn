//
//  HomeViewController.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 3/31/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var contactOrNotLabel: UILabel!
    
    @IBOutlet weak var contactOrNotImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.isContactEventLoggingEnabled == false {
            UserDefaults.standard.isContactEventLoggingEnabled = true
        }
//        contactOrNotImage.image = #imageLiteral(resourceName: "Dani")
    }
}
