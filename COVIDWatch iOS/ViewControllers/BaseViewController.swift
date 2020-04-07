//
//  Test.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var header = Header()
    let screenSize: CGRect = UIScreen.main.bounds
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(header)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        Header must be drawn here instead of viewDidLoad(), because it makes use
//        of view.safeAreaInsets.top which isn't filled out until this point in the
//        ViewController life cycle.
        header.draw(parentVC: self)
    }
}
