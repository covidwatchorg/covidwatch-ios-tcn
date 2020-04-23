//
//  Menu.swift
//  CovidWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/7/20.
//  
//

import UIKit

class MenuItem: UIView {
    weak var parentVC: BaseViewController!
    let text = UILabel()
    var linkImg: UIImageView?
    private var _onClick: () -> Void = {return}
    
    // swiftlint:disable:next function_body_length
    func draw(width: CGFloat, centerX: CGFloat, centerY: CGFloat) {
        self.isUserInteractionEnabled = true
        text.isUserInteractionEnabled = true
        linkImg?.isUserInteractionEnabled = true
        self.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
        self.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
        text.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
        linkImg?.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.onClick)
            )
        )
        self.frame.size.width = width
        self.center.x = centerX
        self.center.y = centerY
        text.font = UIFont(name: "Montserrat-Bold", size: 18)
        text.textColor = UIColor(hexString: "585858")
        text.sizeToFit()
        text.frame.size.width = self.frame.size.width
        self.frame.size.height = (38.0 * figmaToiOSVerticalScalingFactor)
        text.center = self.center
        text.layer.zPosition = 1
        self.addLine(position: .bottom, color: UIColor(hexString: "CCCCCC"), width: 0.5)
        if let linkImg = linkImg {
            linkImg.frame.size.height = text.frame.size.height
            linkImg.frame.size.width = linkImg.frame.size.height
            linkImg.center.y = self.center.y
            linkImg.frame.origin.x = self.frame.maxX - linkImg.frame.size.width
            linkImg.isHidden = true
        }
        text.isHidden = true
        self.isHidden = true
        linkImg?.layer.zPosition = 1
        text.layer.zPosition = 1
        self.layer.zPosition = 1
        
        parentVC.view.addSubview(self)
        parentVC.view.addSubview(text)
        if let linkImg = self.linkImg {
            parentVC.view.addSubview(linkImg)
        }
    }
    
    func toggleShow() {
        self.isHidden = !self.isHidden
        text.isHidden = !text.isHidden
        if let linkImg = linkImg {
            linkImg.isHidden = !linkImg.isHidden
        }
    }
    
    @objc func onClick() {
        self._onClick()
    }
    
    init(_ parentVC: BaseViewController,
         text: String,
         addLinkImg: Bool = false,
         onClick: @escaping () -> Void) {
        self.parentVC = parentVC
        self.text.text = text
        if addLinkImg {
            linkImg = UIImageView(image: UIImage(named: "launch-symbol"))
        }
        self._onClick = onClick
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
