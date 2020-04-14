//
//  Test.swift
//  COVIDWatch iOS
//
//  Created by Nikhil Kumar on 4/13/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

enum TestStatus {
    case unknown
    case positive
    case negative
}

class Test: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var negativeView: UIView!
    @IBOutlet weak var negativeCheckmark: UIView!
    @IBOutlet weak var positiveView: UIView!
    @IBOutlet weak var positiveCheckmark: UIView!
    @IBOutlet weak var showOnPositiveView: UIView!
    @IBOutlet weak var showOnNegativeView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateCheckmark: UIView!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var pickDateView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var close: UIImageView!

    var step = 0
    var pickerData: [String] = [String]()
    var testStatus: TestStatus = .unknown {
        didSet {
            switch testStatus {
            case TestStatus.negative:
                checkNegative()
                uncheckPositive()
            case TestStatus.positive:
                checkPositive()
                uncheckNegative()
            default:
                uncheckPositive()
                uncheckNegative()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        testStatus = .unknown
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBackHome)))

        dateCheckmark.isHidden = true
        datePicker.delegate = self
        datePicker.inputView?.backgroundColor = UIColor.Primary.White
        pickDateView.isHidden = true

        negativeView.layer.borderWidth = 2.0
        negativeView.layer.cornerRadius = 10
        negativeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.testedNegative)))
        negativeView.addConstraint(getButtonHeight(view: negativeView))

        positiveView.layer.borderWidth = 2.0
        positiveView.layer.cornerRadius = 10
        positiveView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.testedPositive)))
        positiveView.addConstraint(getButtonHeight(view: positiveView))

        dateView.layer.borderWidth = 2.0
        dateView.layer.cornerRadius = 10
        dateView.layer.borderColor = UIColor.Secondary.LightGray.cgColor
        dateView.addConstraint(getButtonHeight(view: dateView))
        dateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.pickDate)))

        continueButton.layer.cornerRadius = 10
        continueButton.layer.backgroundColor = UIColor.Primary.Bluejay.cgColor
        continueButton.addConstraint(getButtonHeight(view: continueButton))
        continueButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(submitNegative)))

        reportButton.layer.cornerRadius = 10
        reportButton.layer.backgroundColor = UIColor.Primary.Bluejay.cgColor
        reportButton.addConstraint(getButtonHeight(view: reportButton))
        reportButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(submitPositive)))
        reportView.isHidden = true

        // initialize PickerView dates
        self.initPickerDates()
    }

    @objc func goBackHome() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func testedNegative() {
        testStatus = .negative
    }

    @objc func testedPositive() {
        testStatus = .positive
    }

    @objc func submitNegative() {
        UserDefaults.shared.lastTestedDate = Date()
        performSegue(withIdentifier: "testToHome", sender: self)
    }

    @objc func submitPositive() {
        UserDefaults.shared.isUserSick = true
        UserDefaults.shared.lastTestedDate = Date()
        performSegue(withIdentifier: "testToHome", sender: self)
    }

    @objc func pickDate() {
        dateView.layer.borderColor = UIColor.Secondary.LightGray.cgColor
        if dateLabel.text == "Select Date" {
            dateLabel.text = pickerData[0]
        }
        reportView.isHidden = true
        dateCheckmark.isHidden = true
        pickDateView.isHidden = false
    }

    func initPickerDates() {
        let calendar = Calendar.current
        var endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -13, to: endDate)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        while startDate <= endDate {
            pickerData.append(dateFormatter.string(from: endDate))
            endDate = calendar.date(byAdding: .day, value: -1, to: endDate)!
        }
    }

    func checkPositive() {
        dateView.addConstraint(getButtonHeight(view: dateView))
        positiveView.layer.borderColor = UIColor.Primary.Bluejay.cgColor
        positiveCheckmark.isHidden = false
        showOnPositiveView.isHidden = false
        reportView.isHidden = dateCheckmark.isHidden
    }

    func checkNegative() {
        negativeView.layer.borderColor = UIColor.Primary.Bluejay.cgColor
        negativeCheckmark.isHidden = false
        showOnNegativeView.isHidden = false
    }

    func uncheckPositive() {
        positiveView.layer.borderColor = UIColor.Primary.Gray.cgColor
        positiveCheckmark.isHidden = true
        showOnPositiveView.isHidden = true
        reportView.isHidden = true
        pickDateView.isHidden = true
    }

    func uncheckNegative() {
        negativeView.layer.borderColor = UIColor.Primary.Gray.cgColor
        negativeCheckmark.isHidden = true
        showOnNegativeView.isHidden = true
    }

    func getButtonHeight(view: Any!) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: view!,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: (58.0/321.0) * contentMaxWidth
        )
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dateLabel.text = pickerData[row]
    }

    @IBAction func onPickDate(_ sender: Any) {
        dateView.layer.borderColor = UIColor.Primary.Bluejay.cgColor
        dateCheckmark.isHidden = false
        pickDateView.isHidden = true
        reportView.isHidden = false
    }
}
