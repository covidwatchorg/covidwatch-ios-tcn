//
//  share.swift
//  COVIDWatch iOS
//
//  Created by Laima Cernius-Ink on 4/8/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class share: BaseViewController {
    var logo: UIImageView?
    var img: UIImageView?
    var largeText = LargeText(text: "Share & Protect")
    var share2 = MainText()
    var spread = Button(text: "Spread the word", subtext: "It works best when everyone uses it.")
    var tested = Button(text: "Tested for COVID-19?", subtext: "Share your result anonymously to help keep your community stay safe.")
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
        
        share2.text =  "Covid Watch is using bluetooth to anonymously watch who you come in contact with. You will be notified of potential contact to COVID-19."
        share2.frame.size.height = share2.contentSize.height
        share2.center.x = view.center.x
        share2.center.y = largeText.center.y + largeText.frame.size.height/2 + 60
        share2.isEditable = false
        view.addSubview(share2)
        
        spread.center.x = view.center.x
        spread.center.y = share2.center.y + share2.frame.size.height/2 + 40
        spread.draw(parentVC: self)
        
        tested.center.x = view.center.x
        tested.center.y = spread.subtext!.center.y + spread.subtext!.frame.size.height/2 + 40
        tested.backgroundColor = .clear
        tested.layer.borderWidth = 1
        tested.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        tested.text.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        self.tested.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.test)))
        tested.draw(parentVC: self)
    }
    @objc func test(){
         performSegue(withIdentifier: "test", sender: self)
    }
    
}
