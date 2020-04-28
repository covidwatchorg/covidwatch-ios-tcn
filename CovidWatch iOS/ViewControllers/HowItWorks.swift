//
//  HowItWorks.swift
//  CovidWatch iOS
//
//  Created by Nikhil Kumar on 4/23/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

protocol HowItWorksDelegate: class {
    func btnTapped()
    func indexWasRequested(index: Int)
}

class HowItWorks: UIViewController {
    @IBOutlet weak var page1: UIView!
    @IBOutlet weak var page2: UIView!
    @IBOutlet weak var page3: UIView!
    @IBOutlet weak var page4: UIView!
    @IBOutlet weak var howItWorksLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var setupButton: UIButton!
    @IBAction func setupButtonPressed(_ sender: UIButton) {
        self.delegate?.btnTapped()
    }
    @IBOutlet var setupButtonHeight: NSLayoutConstraint!
    @IBOutlet var setupButtonWidth: NSLayoutConstraint!
    @IBOutlet var howItWorksWidth: NSLayoutConstraint!
    @IBOutlet var titleWidth: NSLayoutConstraint!
    @IBOutlet var descriptionWidth: NSLayoutConstraint!
    static var numPages = 4
    weak var delegate: HowItWorksDelegate?
    
    static func createAll(delegate: HowItWorksDelegate) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "\(HowItWorks.self)", bundle: nil)
        return (1...Self.numPages).compactMap { index in
            let identifier = "\(HowItWorks.self)\(index)"
            let howItWorks = storyboard.instantiateViewController(identifier: identifier) as? HowItWorks
            howItWorks?.delegate = delegate
            howItWorks?.view.tag = index
            return howItWorks
        }
    }

    override func updateViewConstraints() {
        if let setupButtonHeight = self.setupButtonHeight {
            setupButtonHeight.constant = (58.0/321.0) * contentMaxWidth
            setupButtonWidth.constant = contentMaxWidth
        }
        howItWorksWidth.constant = contentMaxWidth
        titleWidth.constant = contentMaxWidth
        descriptionWidth.constant = contentMaxWidth
        super.updateViewConstraints()
    }
    
    func addTapGesture(view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pageTapped(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // accessibility identifiers
        setupAccessibilityAndLocalization()

        // since screen 4 does not have pages
        if let page1 = self.page1,
            let page2 = self.page2,
            let page3 = self.page3,
            let page4 = self.page4 {
            page1.layer.cornerRadius = 10
            page2.layer.cornerRadius = 10
            page3.layer.cornerRadius = 10
            page4.layer.cornerRadius = 10
            addTapGesture(view: page1)
            addTapGesture(view: page2)
            addTapGesture(view: page3)
            addTapGesture(view: page4)
        }
        // user has reached last screen
        if let setupButton = self.setupButton {
            setupButton.layer.cornerRadius = 10
            setupButton.titleLabel?.font = Font.button.font(viewHeight: screenHeight)
            if !UserDefaults.shared.isFirstTimeUser {
                setupButton.setTitle("Done", for: .normal)
            }
        }
        howItWorksLabel.font = UIFont(name: "Montserrat", size: 14)
        howItWorksLabel.textColor = UIColor.Primary.Gray
        titleLabel.font = Font.large.font(viewHeight: screenHeight)
        titleLabel.textColor = UIColor.Primary.Gray
        descriptionLabel.font = Font.main.font(viewHeight: screenHeight)
        descriptionLabel.textColor = UIColor.Primary.Gray
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let headerViewController = segue.destination as? HeaderViewController {
            headerViewController.delegate = self
        }
    }

    func setupAccessibilityAndLocalization() {
        titleLabel.accessibilityIdentifier = AccessibilityIdentifier.LargeText.rawValue
        descriptionLabel.accessibilityIdentifier = AccessibilityIdentifier.MainText.rawValue
    }

    private func nextScreen() {
        if UserDefaults.shared.isFirstTimeUser {
            self.performSegue(withIdentifier: "HowItWorksToBluetooth", sender: self)
        } else {
            self.performSegue(withIdentifier: "HowItWorksToHome", sender: self)
        }
    }
    
    @objc func pageTapped(gesture: UITapGestureRecognizer) {
        if gesture.view == self.page1 {
            self.delegate?.indexWasRequested(index: 0)
        } else if gesture.view == self.page2 {
            self.delegate?.indexWasRequested(index: 1)
        } else if gesture.view == self.page3 {
            self.delegate?.indexWasRequested(index: 2)
        } else if gesture.view == self.page4 {
            self.delegate?.indexWasRequested(index: 3)
        }
    }
}

// MARK: - Protocol HeaderViewControllerDelegate
extension HowItWorks: HeaderViewControllerDelegate {
    func menuWasTapped() { print("not implemented") }
    var shouldShowMenu: Bool { false }
}
