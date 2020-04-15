//
//  Confirm.swift
//  COVIDWatch iOS
//
//  Created by Nikhil Kumar on 4/14/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Confirm: UIViewController {
    @IBOutlet var boxView: UIView!
    @IBOutlet var slideButton: UIView!
    @IBOutlet var slideView: UIView!
    @IBOutlet var slideToConfirmText: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var cancelTopSpace: NSLayoutConstraint!
    @IBOutlet var detailTopSpace: NSLayoutConstraint!
    @IBOutlet var topSpace: NSLayoutConstraint!
    @IBOutlet var boxTopSpace: NSLayoutConstraint!
    @IBOutlet var testTopSpace: NSLayoutConstraint!
    @IBOutlet var slideTopSpace: NSLayoutConstraint!

    public var testedDate: Date = Date()
    var ogSlideButtonPosition: CGPoint? = CGPoint.zero
    var slideStartPosition: CGFloat = 0.0
    var slideEndPosition: CGFloat = 0.0
    var slideCurrentPosition: CGFloat = 0.0
    var btnWidth: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        slideButton.layer.cornerRadius = 4
        slideButton.layer.borderWidth = 4
        slideButton.layer.borderColor = UIColor.Primary.White.cgColor
        slideButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onSlide)))
        btnWidth = slideButton.bounds.width

        slideView.layer.cornerRadius = 10
        slideStartPosition = slideView.bounds.minX + 8
        let sliderWidth = slideView.bounds.width - 16
        slideEndPosition = slideStartPosition + sliderWidth

        boxView.layer.cornerRadius = 10
        boxView.layer.borderWidth = 1
        boxView.layer.borderColor = UIColor.Secondary.LightGray.cgColor

        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.Secondary.LightGray.cgColor
    }

    @objc func onSlide(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            ogSlideButtonPosition = gesture.view?.center
        }
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: slideView)
            if let xPos = gesture.view?.center.x,
                let yPos = gesture.view?.center.y,
                let gView = gesture.view {
                let viewFrame1 = slideView.convert(gView.frame, from: slideButton)
                let currentLeftPos = viewFrame1.minX + translation.x
                slideCurrentPosition = xPos + translation.x + (btnWidth / 2.0)
                slideToConfirmText.alpha = 1.0 - 2 * (slideCurrentPosition / slideEndPosition)
                if currentLeftPos > slideStartPosition && slideCurrentPosition < slideEndPosition {
                    gesture.view?.center = CGPoint(x: xPos + translation.x, y: yPos)
                    gesture.setTranslation(CGPoint.zero, in: slideView)
                }
                if slideCurrentPosition >= slideEndPosition {
                    onConfirm()
                }
            }
        }
        if gesture.state == .ended {
            if let pos = ogSlideButtonPosition {
                gesture.view?.center = pos
                gesture.setTranslation(CGPoint.zero, in: slideView)
            }
            slideToConfirmText.alpha = 1.0
        }
    }

    func onConfirm() {
        UserDefaults.shared.isUserSick = true
        UserDefaults.shared.lastTestedDate = Date()
        performSegue(withIdentifier: "confirmToHome", sender: self)
    }
}

extension Confirm {
    override func updateViewConstraints() {
        topSpace.constant = (30.0/321.0) * contentMaxWidth
        boxTopSpace.constant = (15.0/321.0) * contentMaxWidth
        testTopSpace.constant = (15.0/321.0) * contentMaxWidth
        slideTopSpace.constant = (15.0/321.0) * contentMaxWidth
        cancelTopSpace.constant = (15.0/321.0) * contentMaxWidth
        detailTopSpace.constant = (5.0/321.0) * contentMaxWidth

        if let slideView = self.slideView {
            slideView.addConstraint(getButtonHeight(view: slideView))
        }
        if let cancelButton = self.cancelButton {
            cancelButton.addConstraint(getButtonHeight(view: cancelButton))
        }

        super.updateViewConstraints()
    }

    func getButtonHeight(view: Any) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: view,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: (58.0/321.0) * contentMaxWidth
        )
    }
}
