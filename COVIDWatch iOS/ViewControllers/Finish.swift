//
//  Bluetooth.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//


import UIKit

class Finish: UIViewController {
    let screenSize: CGRect = UIScreen.main.bounds
    var appTitle = UILabel()
    var icon: UIImageView?
    var parkImage: UIImageView?
    var allSet = UITextView()
    var finishButton = UIView()
    var finishLabel = UILabel()
    var description2 = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let scalingFactor = CGFloat(screenHeight) / CGFloat(896)
        var fontScalingFactor = CGFloat(1.0)
        if screenHeight <= 736.0 { fontScalingFactor = scalingFactor }
        print("ScreenHeight = \(screenHeight)")
        
        self.view.backgroundColor = UIColor(hexString: "FFFFFF")

        icon = UIImageView(image: UIImage(named: "logo-cw-color"))
        icon!.frame.size.width = 41
        icon!.frame.size.height = 39
        icon!.center.x = view.center.x
        icon!.center.y = 100
        if screenHeight <= 736.0 { icon!.center.y *= scalingFactor }
        self.view.addSubview(icon!)
        appTitle.text =  "COVID WATCH"
        appTitle.textColor = UIColor(hexString: "F05452")
        appTitle.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        appTitle.sizeToFit()
        appTitle.center.x = view.center.x
        appTitle.center.y = icon!.center.y + icon!.frame.size.height/2 + 15
        self.view.addSubview(appTitle)
        
        parkImage = UIImageView(image: UIImage(named: "sp-people-in-park-colorized-2"))
        parkImage!.frame.size.width = screenWidth
        parkImage!.center.x = view.center.x
        parkImage!.center.y = appTitle.center.y + parkImage!.image!.size.height/2 + (scalingFactor * 40 )
        view.addSubview(parkImage!)
        
        allSet.text =  "You are all set!"
        allSet.textColor = UIColor(hexString: "585858")
        allSet.font = UIFont(name: "Optima-Bold", size: fontScalingFactor * 36)
        allSet.frame.size.width = 330
        allSet.frame.size.height = allSet.contentSize.height
        allSet.isEditable = false
        allSet.backgroundColor = .clear
        allSet.center.x = view.center.x
        allSet.center.y = parkImage!.center.y + parkImage!.image!.size.height/2
        view.addSubview(allSet)
        
        description2.text =  "Covid Watch is now using bluetooth to anonymously watch who you come in contact with. You will be notified of potential contact to COVID-19."
        description2.textColor = UIColor(hexString: "585858")
        description2.font = UIFont(name: "Montserrat-Regular", size: fontScalingFactor * 18)
        description2.frame.size.width = 330
        description2.frame.size.height = description2.contentSize.height
        description2.isEditable = false
        description2.backgroundColor = .clear
        description2.center.x = view.center.x
        description2.center.y = allSet.center.y + description2.frame.size.height / 2 + scalingFactor * 20
        view.addSubview(description2)
        
        finishButton.frame.size.width = description2.frame.size.width
        finishButton.frame.size.height = 60
        finishButton.center.x = view.center.x
        finishButton.center.y = description2.center.y + description2.frame.size.height/2 + finishButton.frame.size.height/2 + (scalingFactor * 10)
        finishButton.backgroundColor = UIColor(hexString: "496FB6")
        finishButton.layer.cornerRadius = 10
        self.finishButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextScreen)))
        view.addSubview(finishButton)

        finishLabel.text =  "Finish"
        finishLabel.textColor = .white
        finishLabel.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        finishLabel.sizeToFit()
        finishLabel.center = finishButton.center
        view.addSubview(finishLabel)
        
        
        
        

    }
        
    @objc func nextScreen(sender : UITapGestureRecognizer) {
        if sender.state == .ended {
            performSegue(withIdentifier: "FinishToHome", sender: self)
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
