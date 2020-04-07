//
//  share.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/7/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class share: UIViewController {
    var logo: UIImageView?
    var img: UIImageView?
    var share = UILabel()
    var share2 = UITextView()
    
    var spread = UIView()
    var spreadLbl = UILabel()
    var spreadLbl2 = UILabel()
    
    var tested = UIView()
    var testedLbl = UILabel()
    var testedLbl2 = UITextView()
    
    let screenSize: CGRect = UIScreen.main.bounds
    var scalingFactor: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        self.scalingFactor = CGFloat(screenHeight) / CGFloat(896)
        var fontScalingFactor = CGFloat(1.0)
        if screenHeight <= 736.0 { fontScalingFactor = scalingFactor! }
        print("ScreenHeight = \(screenHeight)")
        
        var imagea: UIImage = UIImage(named: "logo-cw (3)")!
        logo = UIImageView(image: imagea)
        logo!.frame.size.width = 39
        logo!.frame.size.height = 39
        
        logo!.center.x = view.center.x - 140
        logo!.center.y = 75
        if screenHeight <= 736.0 { logo!.center.y *= scalingFactor! }
        self.view.addSubview(logo!)
        
        var imageb: UIImage = UIImage(named: "woman-hero-blue-2")!
        img = UIImageView(image: imageb)
        img!.frame.size.width = 253
        img!.frame.size.height = 259
        
        img!.center.x = view.center.x - 5
        img!.center.y = 240
        if screenHeight <= 736.0 { img!.center.y *= scalingFactor! }
        self.view.addSubview(img!)
        
        
        share.text =  "Share & Protect"
        share.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        share.font = UIFont(name: "Montserrat-SemiBold", size: 36 * fontScalingFactor)
        share.sizeToFit()
        share.center.x = view.center.x
        share.center.y = img!.center.y + img!.frame.size.height/2 + 40
        
        view.addSubview(share)
        
        share2.text =  "Covid Watch is using bluetooth to anonymously watch who you come in contact with. You will be notified of potential contact to COVID-19."
        share2.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        share2.font = UIFont(name: "Montserrat-Regular", size: 18 * fontScalingFactor)
        share2.frame.size.width = 300
        share2.frame.size.height = 125
        share2.center.x = view.center.x
        share2.center.y = share.center.y + share.frame.size.height/2 + 60
        share2.textAlignment = .center
        view.addSubview(share2)
        
        spread.frame.size.width = share2.frame.size.width
        spread.frame.size.height = 58
        spread.center.x = view.center.x
        spread.center.y = share2.center.y + share2.frame.size.height/2 + 40
        spread.backgroundColor = UIColor(red: 0.286, green: 0.435, blue: 0.714, alpha: 1)
        spread.layer.cornerRadius = 10
        //    self.spread.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextScreen)))
        view.addSubview(spread)
        spreadLbl.text =  "Spread the word"
        spreadLbl.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        spreadLbl.font = UIFont(name: "Montserrat-Bold", size: 18 * fontScalingFactor)
        spreadLbl.sizeToFit()
        spreadLbl.center.x = spread.center.x
        spreadLbl.center.y = spread.center.y
        
        view.addSubview(spreadLbl)
        
        spreadLbl2.text =  "It works best when everyone uses it."
        spreadLbl2.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        spreadLbl2.font = UIFont(name: "Montserrat-Regular", size: 14 * fontScalingFactor)
        spreadLbl2.sizeToFit()
        spreadLbl2.center.x = spread.center.x
        spreadLbl2.center.y = spreadLbl.center.y + spreadLbl.frame.size.height/2 + 40
        
        view.addSubview(spreadLbl2)
        
        tested.frame.size.width = share2.frame.size.width
        tested.frame.size.height = 58
        tested.center.x = view.center.x
        tested.center.y = spreadLbl2.center.y + spreadLbl2.frame.size.height/2 + 40
        tested.backgroundColor = .clear
        tested.layer.borderWidth = 1
        tested.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        tested.layer.cornerRadius = 10
        //    self.spread.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextScreen)))
        view.addSubview(tested)
        
        testedLbl.text =  "Tested for COVID-19?"
        testedLbl.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        testedLbl.font = UIFont(name: "Montserrat-Bold", size: 18 * fontScalingFactor)
        testedLbl.sizeToFit()
        testedLbl.center.x = tested.center.x
        testedLbl.center.y = tested.center.y
        
        view.addSubview(testedLbl)
        
        testedLbl2.text =  "Share your result anonymously to help your community stay safe."
        testedLbl2.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        testedLbl2.font = UIFont(name: "Montserrat-Regular", size: 14 * fontScalingFactor)
        testedLbl2.frame.size.width = tested.frame.size.width
        testedLbl2.frame.size.height = 100
        testedLbl2.center.x = spread.center.x
        testedLbl2.center.y = testedLbl.center.y + testedLbl.frame.size.height/2 + 80
        testedLbl2.textAlignment = .center
        view.addSubview(testedLbl2)
    }
    
    
}
