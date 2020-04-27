//
//  Entry.swift
//  CovidWatch iOS
//
//  Created by Nikhil Kumar on 4/12/20.
//  
//

import UIKit

class Entry: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.shared.isFirstTimeUser {
            performSegue(withIdentifier: "goToOnboarding", sender: self)
        } else {
            performSegue(withIdentifier: "goToHome", sender: self)
        }
    }
    
}
