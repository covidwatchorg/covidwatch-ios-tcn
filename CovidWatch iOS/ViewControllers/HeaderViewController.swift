//
//  HeaderViewController.swift
//  CovidWatch iOS
//
//  Created by Jeff Lett on 4/25/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

/// Implement this in any view controllers that need a header
protocol HeaderViewControllerDelegate: class {
    var shouldShowMenu: Bool { get }
    func menuWasTapped()
}
// Default implementation of the protocol,
// so only override this if you want to hide the menu
extension HeaderViewControllerDelegate {
    var shouldShowMenu: Bool {
        true
    }
}

class HeaderViewController: UIViewController {
    weak var delegate: HeaderViewControllerDelegate?
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnMenu.isHidden = !(self.delegate?.shouldShowMenu ?? true)
        #if DEBUG
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(btnLogoTapped(_:)))
        self.img.addGestureRecognizer(tapGesture)
        self.img.isUserInteractionEnabled = true
        #endif
    }
    
    @IBAction func btnMenuTapped(_ sender: Any) {
        self.delegate?.menuWasTapped()
    }
    
    @objc func btnLogoTapped(_ sender: Any) {
        #if DEBUG
        UserDefaults.standard.isFirstTimeUser = true
        self.navigationController?.popToRootViewController(animated: true)
        #endif
    }
}
