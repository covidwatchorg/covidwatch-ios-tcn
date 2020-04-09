//
//  share.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/8/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Share: BaseViewController {
    var img: UIImageView?
    var largeText = LargeText(text: "Share & Protect")
    var mainText = MainText(text: "Covid Watch is using bluetooth to anonymously watch who you come in contact with. You will be notified of potential contact to COVID-19.")
    var spreadButton = Button(text: "Spread the word", subtext: "It works best when everyone uses it.")
    var testedButton = Button(text: "Tested for COVID-19?", subtext: "Share your result anonymously to help keep your community stay safe.")
    let screenSize: CGRect = UIScreen.main.bounds
    var scalingFactor: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scalingFactor = CGFloat(screenHeight) / CGFloat(896)
        let imageb: UIImage = UIImage(named: "woman-hero-blue-2")!
        img = UIImageView(image: imageb)
        img!.frame.size.width = 253
        img!.frame.size.height = 259
        
        img!.center.x = view.center.x - 5
        img!.center.y = 240
        if screenHeight <= 736.0 { img!.center.y *= scalingFactor! }
        self.view.addSubview(img!)
        
        largeText.draw(parentVC: self, centerX: view.center.x, centerY: img!.center.y + img!.frame.size.height/2 + 40)
        
        mainText.draw(parentVC: self, centerX: view.center.x, originY: largeText.center.y + largeText.frame.size.height/2 + 60)
        
        spreadButton.draw(parentVC: self, centerX: view.center.x, centerY: mainText.center.y + mainText.frame.size.height/2 + 40)
        
        self.testedButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.test)))
        testedButton.draw(parentVC: self, centerX: view.center.x, centerY: spreadButton.subtext!.center.y + spreadButton.subtext!.frame.size.height/2 + 40)
        testedButton.backgroundColor = .clear
        testedButton.layer.borderWidth = 1
        testedButton.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        testedButton.text.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
    }
    @objc func test(){
         performSegue(withIdentifier: "test", sender: self)
    }
    
}
