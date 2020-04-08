//
//  thankyou.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/7/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class thankyou: UIViewController {
    var thankyouLbl = UITextView()
    
    var explain = UITextView()
    
    var logo: UIImageView?
    
    var continued = UIView()
    var continuedLbl = UILabel()
    
    var scalingFactor: CGFloat?
    let screenSize: CGRect = UIScreen.main.bounds
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scalingFactor = CGFloat(screenHeight) / CGFloat(896)
        var fontScalingFactor = CGFloat(1.0)
        if screenHeight <= 736.0 { fontScalingFactor = scalingFactor! }
        print("ScreenHeight = \(screenHeight)")
        thankyouLbl.text =  "Thank you for helping your community."
        thankyouLbl.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        thankyouLbl.font = UIFont(name: "Montserrat-Black", size: 36 )
        thankyouLbl.frame.size.width = 300
        thankyouLbl.frame.size.height = 200
        thankyouLbl.center.x = view.center.x - 10
        thankyouLbl.center.y = 125
        
        
        
        
        view.addSubview(thankyouLbl)
        
        
        var imagea: UIImage = UIImage(named: "image")!
        logo = UIImageView(image: imagea)
        logo!.frame.size.width = 375
        logo!.frame.size.height = 308
        
        logo!.center.x = view.center.x
        logo!.center.y = thankyouLbl.center.y + thankyouLbl.frame.size.height/2 + 100
        view.addSubview(logo!)
        
        
        explain.text =  "By using this app and reporting your test results anonymously, you have helped others be more careful and helped reduce the spread."
        explain.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        explain.font = UIFont(name: "Montserrat-Regular", size: 18 * fontScalingFactor)
        explain.frame.size.width = 300
        explain.frame.size.height = 100
        explain.center.x = view.center.x
        explain.center.y = logo!.center.y + logo!.frame.size.height/2 + 50
        explain.textAlignment = .center
        view.addSubview(explain)
        
        
        
        continued.frame.size.width = explain.frame.size.width
        continued.frame.size.height = 75
        continued.center.x = view.center.x
        continued.center.y = explain.center.y + explain.frame.size.height/2 + 50
        continued.backgroundColor = UIColor(red: 0.286, green: 0.435, blue: 0.714, alpha: 1)
        continued.layer.cornerRadius = 20
        view.addSubview(continued)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Continue))
        
        continued.addGestureRecognizer(tap)
        continuedLbl.text =  "Continue"
        continuedLbl.textColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        continuedLbl.font = UIFont(name: "Montserrat-Bold", size: 21)
        continuedLbl.sizeToFit()
        continuedLbl.center = continued.center
        
        view.addSubview(continuedLbl)
        
        
        
    }
    @objc func Continue() {
        performSegue(withIdentifier: "home", sender: nil)
    }
}
