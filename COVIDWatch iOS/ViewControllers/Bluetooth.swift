//
//  Bluetooth.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//


import UIKit

class Bluetooth: UIViewController {
    let screenSize: CGRect = UIScreen.main.bounds
    var appTitle = UILabel()
    var icon: UIImageView?
    var parkImage: UIImageView?
    var description1 = UITextView()
    var allowBtButton = UIView()
    var allowBtLabel = UILabel()
    var description2 = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        var scalingFactor = CGFloat(screenHeight) / CGFloat(896)
        print("ScreenHeight = \(screenHeight)")
        if screenHeight <= 736.0 {

            scalingFactor /= 2
        }
        
        self.view.backgroundColor = UIColor(hexString: "FFFFFF")

        icon = UIImageView(image: UIImage(named: "logo-cw-color"))
        icon!.frame.size.width = 41
        icon!.frame.size.height = 39
        icon!.center.x = view.center.x
        icon!.center.y = scalingFactor * 100
        self.view.addSubview(icon!)
        appTitle.text =  "COVID WATCH"
        appTitle.textColor = UIColor(hexString: "F05452")
        appTitle.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        appTitle.sizeToFit()
        appTitle.center.x = view.center.x
        appTitle.center.y = icon!.center.y + icon!.frame.size.height/2 + (scalingFactor * 15)
        self.view.addSubview(appTitle)
        
        parkImage = UIImageView(image: UIImage(named: "sp-people-in-park-colorized-0"))
        parkImage!.frame.size.width = screenWidth
        parkImage!.center.x = view.center.x
        parkImage!.center.y = appTitle.center.y + parkImage!.image!.size.height/2 + (scalingFactor * 40)
        view.addSubview(parkImage!)
        
        description1.text =  "Covid Watch uses bluetooth to anonymously watch who you come in contact with."
        description1.textColor = UIColor(hexString: "585858")
        description1.font = UIFont(name: "Montserrat-Regular", size: 18)
        description1.frame.size.width = 330
        description1.frame.size.height = 75
        description1.isEditable = false
        description1.backgroundColor = .clear
        description1.center.x = view.center.x
        description1.center.y = parkImage!.center.y + parkImage!.image!.size.height/2 + (scalingFactor * 40)
        view.addSubview(description1)
        
        allowBtButton.frame.size.width = description1.frame.size.width
        allowBtButton.frame.size.height = 60
        allowBtButton.center.x = view.center.x
        allowBtButton.center.y = description1.center.y + description1.frame.size.height/2 + (scalingFactor * 60)
        allowBtButton.backgroundColor = UIColor(hexString: "496FB6")
        allowBtButton.layer.cornerRadius = 10
        view.addSubview(allowBtButton)

        allowBtLabel.text =  "Allow Bluetooth"
        allowBtLabel.textColor = .white
        allowBtLabel.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        allowBtLabel.sizeToFit()
        allowBtLabel.center = allowBtButton.center
        view.addSubview(allowBtLabel)
        
        description2.text =  "This is required for the app to work."
        description2.textColor = UIColor(hexString: "585858")
        description2.font = UIFont(name: "Montserrat-Regular", size: 14)
        description2.sizeToFit()
        description2.isEditable = false
        description2.backgroundColor = .clear
        description2.center.x = view.center.x
        description2.center.y = allowBtButton.center.y + allowBtButton.frame.size.height/2 + (scalingFactor * 20)
        view.addSubview(description2)
        
        

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
