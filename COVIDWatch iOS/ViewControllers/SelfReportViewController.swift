//
//  SelfReportViewController.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/2/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

struct ConfirmationButtonsSelector {
    var yesButton: Bool = false {
        didSet {
            if yesButton == true {
                noButton = false
                notTestedButton = false
            }
        }
    }
    var noButton: Bool = false {
        didSet {
            if noButton == true {
                yesButton = false
                notTestedButton = false
            }
        }
    }
    var notTestedButton: Bool = false {
        didSet {
            if notTestedButton == true {
                yesButton = false
                noButton = false
            }
        }
    }
}

class SelfReportViewController: UIViewController {

    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var notTestedButton: UIButton!
    var confirmationSelector: confirmationButtonsSelector {
        didSet {
            toggleConfirmationButtonColors()
        }
    }

    required init?(coder: NSCoder) {
        self.confirmationSelector = confirmationButtonsSelector()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonInit()
    }

    private func buttonInit() {
        reportButton.layer.cornerRadius = 10
        reportButton.isEnabled = false
        reportButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.25)
        yesButton.layer.cornerRadius = 5
        noButton.layer.cornerRadius = 5
        notTestedButton.layer.cornerRadius = 5
    }

    private func yesNoOrNotTestedPressed(_ sender: UIButton) {
        switch sender {
        case yesButton:
            self.confirmationSelector.yesButton = true
        case noButton:
            self.confirmationSelector.noButton = true
        case notTestedButton:
            self.confirmationSelector.notTestedButton = true
        default:
            self.confirmationSelector.yesButton = false
            self.confirmationSelector.noButton = false
            self.confirmationSelector.notTestedButton = false
        }
    }

    private func toggleConfirmationButtonColors() {
        if self.confirmationSelector.yesButton == true {
            yesButton.backgroundColor = UIColor(hexString: "#779f98")
        } else {
            yesButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.25)
        }

        if self.confirmationSelector.noButton == true {
            noButton.backgroundColor = UIColor(hexString: "#779f98")
        } else {
            noButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.25)
        }

        if self.confirmationSelector.notTestedButton == true {
            notTestedButton.backgroundColor = UIColor(hexString: "#779f98")
        } else {
            notTestedButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.25)
        }

        reportButton.backgroundColor = UIColor(hexString: "#bf3f4a")
        reportButton.isEnabled = true
    }

    @IBAction func yesButtonPressed(_ sender: UIButton) {
        yesNoOrNotTestedPressed(sender)
    }
    @IBAction func noButtonPressed(_ sender: UIButton) {
        yesNoOrNotTestedPressed(sender)
    }
    @IBAction func notTestedPressed(_ sender: UIButton) {
        yesNoOrNotTestedPressed(sender)
    }
}
