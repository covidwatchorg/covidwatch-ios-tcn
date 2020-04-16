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
    @IBOutlet var reportTopSpace: NSLayoutConstraint!
    @IBOutlet var continueTopSpace: NSLayoutConstraint!
    @IBOutlet var dateTopSpace: NSLayoutConstraint!
    @IBOutlet var detailsTopSpace: NSLayoutConstraint!
    @IBOutlet var negativeTopSpace: NSLayoutConstraint!
    @IBOutlet var positiveTopSpace: NSLayoutConstraint!
    @IBOutlet var titleTopSpace: NSLayoutConstraint!

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

        positiveView.layer.borderWidth = 2.0
        positiveView.layer.cornerRadius = 10
        positiveView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.testedPositive)))

        dateView.layer.borderWidth = 2.0
        dateView.layer.cornerRadius = 10
        dateView.layer.borderColor = UIColor.Secondary.LightGray.cgColor
        dateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.pickDate)))

        continueButton.layer.cornerRadius = 10
        continueButton.layer.backgroundColor = UIColor.Primary.Bluejay.cgColor
        continueButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(submitNegative)))

        reportButton.layer.cornerRadius = 10
        reportButton.layer.backgroundColor = UIColor.Primary.Bluejay.cgColor
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
        performSegue(withIdentifier: "confirmTest", sender: self)
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
        
        guard let startDate = calendar.date(byAdding: .day, value: -30, to: endDate) else {
            print("\(#function): Error Creating date")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        while startDate <= endDate {
            pickerData.append(dateFormatter.string(from: endDate))
            if let date = calendar.date(byAdding: .day, value: -1, to: endDate) {
                endDate = date
            }
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

    // MARK: - Pass testedDate to Confirm
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmTest" {
            if let confirmVC = segue.destination as? Confirm {
                if let dateString = dateLabel.text {
                    let df = DateFormatter()
                    if let date = df.date(from: dateString) {
                        confirmVC.testedDate = date
                    }
                }
            }
        }
    }

    // MARK: - PickerView functions
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

// MARK: - Layout Constraints
extension Test {
    override func updateViewConstraints() {
        negativeView.addConstraint(getButtonHeight(view: negativeView))
        positiveView.addConstraint(getButtonHeight(view: positiveView))
        dateView.addConstraint(getButtonHeight(view: dateView))
        continueButton.addConstraint(getButtonHeight(view: continueButton))
        reportButton.addConstraint(getButtonHeight(view: reportButton))

        titleTopSpace.constant = (30.0/321.0) * contentMaxWidth
        detailsTopSpace.constant = (30.0/321.0) * contentMaxWidth

        negativeTopSpace.constant = (15.0/321.0) * contentMaxWidth
        dateTopSpace.constant = (15.0/321.0) * contentMaxWidth
        continueTopSpace.constant = (15.0/321.0) * contentMaxWidth

        reportTopSpace.constant = (5.0/321.0) * contentMaxWidth
        positiveTopSpace.constant = (5.0/321.0) * contentMaxWidth

        super.updateViewConstraints()
    }

    func getButtonHeight(view: UIView) -> NSLayoutConstraint {
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
