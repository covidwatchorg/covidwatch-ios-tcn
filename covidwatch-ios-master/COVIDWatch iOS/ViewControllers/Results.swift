//
//  Results.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/5/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Results: UIViewController {
    var thanks = UITextView()
      var descriptionLbl = UITextView()
     var continuedLbl = UILabel()
      var continued = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()

           
          thanks.text =  "Thank you for helping your community."
                                             thanks.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
             thanks.font = UIFont(name: "Avenir-Extrabold", size: 24)
                  thanks.frame.size.width = 300
                  thanks.frame.size.height = 100
                  thanks.textAlignment = .center
             thanks.center.x = view.center.x
            thanks.center.y = view.center.y - 275

            view.addSubview(thanks)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
