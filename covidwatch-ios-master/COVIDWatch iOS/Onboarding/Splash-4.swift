//
//  Splash-4.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Splash_4: UIViewController {
    let screenSize: CGRect = UIScreen.main.bounds
var title1 = UILabel()
var icon: UIImageView?
     var description1 = UITextView()
    var start = UIView()
    var startLbl = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = screenSize.width
                                        let screenHeight = screenSize.height
        
        self.view.backgroundColor = UIColor(red: 0.941, green: 0.329, blue: 0.322, alpha: 1)


        var imagea: UIImage = UIImage(named: "logo-cw")!
               icon = UIImageView(image: imagea)
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
                description1.sizeToFit()
        description1.isEditable = false
        description1.backgroundColor = .clear
                description1.center.x = view.center.x
               description1.center.y = title1.center.y + screenHeight/3
       view.addSubview(description1)
        
        
        start.frame.size.width = description1.frame.size.width
         start.frame.size.height = 75
        start.center.x = view.center.x
        start.center.y = description1.center.y + 75
        start.backgroundColor = .white
        start.layer.cornerRadius = 20
        view.addSubview(start)

        startLbl.text =  "Start"
                                         startLbl.textColor = .black
         startLbl.font = UIFont(name: "Montserrat-SemiBold", size: 24)
         startLbl.sizeToFit()
         startLbl.center = start.center
       view.addSubview(startLbl)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
                   
                   start.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    @objc func tapped() {
        
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
