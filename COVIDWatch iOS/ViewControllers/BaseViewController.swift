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
    override func loadView() {
        super.loadView()
        header.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(header)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        self.header.backgroundColor = .white
    }
    
//    override func viewDidLoad() {
//    }
}
