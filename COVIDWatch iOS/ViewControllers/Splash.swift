//
//  Splash-4.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Splash: UIViewController {
    let screenSize: CGRect = UIScreen.main.bounds
    var title1 = UILabel()
    var icon: UIImageView?
    var description1 = UITextView()
    var start = UIView()
    var startLbl = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0.941, green: 0.329, blue: 0.322, alpha: 1)

        icon = UIImageView(image: UIImage(named: "logo-cw-white"))
        icon!.frame.size.width = 101
        icon!.frame.size.height = 100
        
        icon!.center.x = view.center.x
        icon!.center.y = 175
        self.view.addSubview(icon!)
        
        title1.text =  "COVID WATCH"
        title1.textColor = .white
        title1.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        title1.sizeToFit()
        title1.center.x = view.center.x
        title1.center.y = icon!.center.y + 100
        view.addSubview(title1)
       
        description1.text =  "Help your community stay safe, anonymously."
        description1.textColor = .white
        description1.font = UIFont(name: "Montserrat-Regular", size: 18)
        description1.textAlignment = .center
        description1.frame.size.width = 330
        description1.frame.size.height = description1.contentSize.height
        description1.isEditable = false
        description1.backgroundColor = .clear
        description1.center.x = view.center.x
        description1.center.y = title1.center.y + (screenHeight/3)
        view.addSubview(description1)
        
        
        start.frame.size.width = description1.frame.size.width
        start.frame.size.height = 75
        start.center.x = view.center.x
        start.center.y = description1.center.y + 75
        start.backgroundColor = .white
        start.layer.cornerRadius = 10
        self.start.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextScreen)))
        view.addSubview(start)

        startLbl.text =  "Start"
        startLbl.textColor = UIColor(hexString: "585858")
        startLbl.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        startLbl.textAlignment = .center
        startLbl.sizeToFit()
        startLbl.center = start.center
        view.addSubview(startLbl)
        
        
    }
    
    @objc func nextScreen(sender : UITapGestureRecognizer) {
        if sender.state == .ended {
            performSegue(withIdentifier: "SplashToBluetooth", sender: self)
        }
    }

    /*
    // MARK: - Navigation
​
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
