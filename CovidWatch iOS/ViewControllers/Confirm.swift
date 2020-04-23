//
//  Confirm.swift
//  CovidWatch iOS
//
//  Created by Nikhil Kumar on 4/14/20.
//  
//

import UIKit

class Confirm: UIViewController {
    @IBOutlet var boxView: UIView!
    @IBOutlet var slideButton: UIView!
    @IBOutlet var slideView: UIView!
    @IBOutlet var slideToConfirmText: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var closeIcon: UIImageView!
    
    @IBOutlet var cancelTopSpace: NSLayoutConstraint!
    @IBOutlet var detailTopSpace: NSLayoutConstraint!
    @IBOutlet var topSpace: NSLayoutConstraint!
    @IBOutlet var boxTopSpace: NSLayoutConstraint!
    @IBOutlet var boxWidth: NSLayoutConstraint!
    @IBOutlet var testTopSpace: NSLayoutConstraint!
    @IBOutlet var slideTopSpace: NSLayoutConstraint!
    @IBOutlet var titleWidth: NSLayoutConstraint!

    public var testedDate: Date = Date()
    var ogSlideButtonPosition: CGPoint = CGPoint.zero
    var slideStartPosition: CGFloat = 0.0
    var slideEndPosition: CGFloat = 0.0
    var slideCurrentPosition: CGFloat = 0.0
    var btnWidth: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        closeIcon.isUserInteractionEnabled = true
        closeIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePage)))

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
        if let gView = gesture.view,
            let xPos = gesture.view?.center.x,
            let yPos = gesture.view?.center.y {

            if gesture.state == .began {
                ogSlideButtonPosition = gView.center
            }
            if gesture.state == .began || gesture.state == .changed {
                let translation = gesture.translation(in: slideView)
                let viewFrame = slideView.convert(gView.frame, from: slideButton)
                let currentLeftPos = viewFrame.minX + translation.x
                slideCurrentPosition = xPos + translation.x + (btnWidth / 2.0)
                let slideDistance = (slideCurrentPosition - ogSlideButtonPosition.x)
                let totalSlideDistance = screenWidth - btnWidth - 94
                slideToConfirmText.alpha = 1.0 - 2 * (slideDistance / totalSlideDistance)
                if currentLeftPos > slideStartPosition && slideDistance < totalSlideDistance {
                    gesture.view?.center = CGPoint(x: xPos + translation.x, y: yPos)
                    gesture.setTranslation(CGPoint.zero, in: slideView)
                } else if slideDistance >= totalSlideDistance {
                    onConfirm()
                }
            }
            if gesture.state == .ended {
                gesture.view?.center = ogSlideButtonPosition
                gesture.setTranslation(CGPoint.zero, in: slideView)
                slideToConfirmText.alpha = 1.0
            }
        }
    }

    func onConfirm() {
        UserDefaults.shared.isUserSick = true
        UserDefaults.shared.testLastSubmittedDate = Date()
        closePage()
    }
    @IBAction func onCancelPressed(_ sender: Any) {
        closePage()
    }
    @objc func closePage() {
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
        boxWidth.constant = contentMaxWidth
        titleWidth.constant = contentMaxWidth

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
