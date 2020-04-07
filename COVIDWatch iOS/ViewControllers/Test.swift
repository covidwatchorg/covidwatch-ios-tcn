//
//  Test.swift
//  COVIDWatch iOS
//
//  Created by Andreas Ink on 4/4/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Test: UIViewController {
    var icon: UIImageView?
    var title1 = UILabel()
    var q1 = UITextView()
    var q2 = UITextView()
    var terms = UITextView()
    var not = UIView()
    var neg = UIView()
    var pos = UIView()
    
    var back = UIView()
    
    var notLbl = UILabel()
    var negLbl = UILabel()
    var posLbl = UILabel()
    
    var confirm = UIView()
    var agree = UIView()
    var disagree = UIView()
    var report = UIView()
    var agreeLbl = UILabel()
    var disagreeLbl = UILabel()
    var reportLbl = UILabel()
    
    var conditionLbl = UITextView()
    var step = 0
    var agreeCount = 0
    var condition = ""
    let screenSize: CGRect = UIScreen.main.bounds
    let timePicker = UIDatePicker()
    
    
    func openTimePicker()  {
        timePicker.datePickerMode = UIDatePicker.Mode.date
        timePicker.frame = CGRect(x: 0.0, y: 1000, width: self.view.frame.width, height: 150.0)
        
        timePicker.backgroundColor = UIColor.white
        self.view.addSubview(timePicker)
        //timePicker.addTarget(self, action: #selector(yourViewControllerName.startTimeDiveChanged), for: UIControlEvents.valueChanged)
    }
    
    func startTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        timePicker.removeFromSuperview() // if you want to remove time picker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openTimePicker()
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        
        var imagea: UIImage = UIImage(named: "logo-cw (3)")!
        icon = UIImageView(image: imagea)
        icon!.frame.size.width = 41
        icon!.frame.size.height = 39
        
        icon!.center.x = view.center.x
        icon!.center.y = 75
        self.view.addSubview(icon!)
        
        
        
        title1.text =  "COVID WATCH"
        title1.textColor = UIColor(red: 0.941, green: 0.329, blue: 0.322, alpha: 1)
        title1.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        title1.sizeToFit()
        title1.center.x = view.center.x
        title1.center.y = icon!.center.y + 50
        
        view.addSubview(title1)
        
        q1.text =  "Have you been tested for COVID-19?"
        q1.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        q1.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        q1.frame.size.width = 300
        q1.frame.size.height = 75
        q1.center.x = view.center.x - 25
        q1.center.y = title1.center.y + 100
        
        view.addSubview(q1)
        
        terms.text =  "By clicking \"Report\", you acknowledge, understand and further agree to our Privacy Policy and Terms & Conditions."
        terms.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        terms.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        terms.frame.size.width = 320
        terms.frame.size.height = 120
        terms.textAlignment = .center
        terms.center.x = view.center.x
        terms.center.y = screenHeight/1.01 + 1000
        terms.alpha = 0
        
        view.addSubview(terms)
        
        q2.text =  "I attest that the information I’ve submitted is true to the best of my knowledge."
        q2.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        q2.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        q2.frame.size.width = 320
        q2.frame.size.height = 100
        
        q2.center.x = view.center.x - 3
        q2.center.y = view.center.y + 1050
        q2.textAlignment = .left
        view.addSubview(q2)
        
        not.frame.size.width = 300
        not.frame.size.height = 75
        not.center.x = view.center.x
        not.center.y = q1.center.y + 125
        not.backgroundColor = UIColor(red: 0.925, green: 0.949, blue: 0.98, alpha: 1)
        not.layer.cornerRadius = 20
        view.addSubview(not)
        
        
        notLbl.text =  "Not yet tested"
        notLbl.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        notLbl.font = UIFont(name: "Montserrat-Bold", size: 21)
        notLbl.sizeToFit()
        notLbl.center = not.center
        
        view.addSubview(notLbl)
        
        neg.frame.size.width = 300
        neg.frame.size.height = 75
        neg.center.x = view.center.x
        neg.center.y = not.center.y + 125
        neg.backgroundColor = UIColor(red: 0.925, green: 0.949, blue: 0.98, alpha: 1)
        neg.layer.cornerRadius = 20
        view.addSubview(neg)
        
        negLbl.text =  "Tested negative"
        negLbl.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        negLbl.font = UIFont(name: "Montserrat-Bold", size: 21)
        negLbl.sizeToFit()
        negLbl.center = neg.center
        
        view.addSubview(negLbl)
        
        pos.frame.size.width = 300
        pos.frame.size.height = 75
        pos.center.x = view.center.x
        pos.center.y = neg.center.y + 125
        pos.backgroundColor = UIColor(red: 0.925, green: 0.949, blue: 0.98, alpha: 1)
        pos.layer.cornerRadius = 20
        
        view.addSubview(pos)
        
        back.frame.size.width = 75
        back.frame.size.height = 75
        back.center.x = view.center.x - 130
        back.center.y = screenHeight/1.07
        back.backgroundColor = UIColor(red: 0.925, green: 0.949, blue: 0.98, alpha: 1)
        back.layer.cornerRadius = 20
        //    view.addSubview(back)
        
        posLbl.text =  "Tested positive"
        posLbl.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        posLbl.font = UIFont(name: "Montserrat-Bold", size: 21)
        posLbl.sizeToFit()
        posLbl.center = pos.center
        
        
        view.addSubview(posLbl)
        
        
        confirm.frame.size.width = 325
        confirm.frame.size.height = 350
        confirm.center.x = view.center.x
        confirm.center.y = view.center.y + 1000
        confirm.layer.borderWidth = 1
        confirm.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        confirm.alpha = 0
        confirm.layer.cornerRadius = 20
        view.addSubview(confirm)
        
        report.frame.size.width = 289
        report.frame.size.height = 58
        report.center.x = view.center.x
        report.center.y = view.center.y + 1000
        report.alpha = 0
        report.backgroundColor = UIColor(red: 0.286, green: 0.435, blue: 0.714, alpha: 1)
        
        report.layer.cornerRadius = 20
        view.addSubview(report)
        
        agree.frame.size.width = 289
        agree.frame.size.height = 58
        agree.center.x = view.center.x
        agree.center.y = view.center.y + 1000
        
        agree.backgroundColor = UIColor(red: 0.286, green: 0.435, blue: 0.714, alpha: 1)
        agree.alpha = 0
        agree.layer.cornerRadius = 20
        view.addSubview(agree)
        disagree.frame.size.width = 289
        disagree.frame.size.height = 58
        disagree.center.x = view.center.x
        disagree.center.y = agree.center.y + 75
        disagree.alpha = 0
        disagree.backgroundColor = UIColor(red: 0.925, green: 0.949, blue: 0.98, alpha: 1)
        
        disagree.layer.cornerRadius = 20
        view.addSubview(disagree)
        
        
        agreeLbl.text =  "Agree"
        agreeLbl.textColor = .white
        agreeLbl.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        agreeLbl.sizeToFit()
        agreeLbl.center = agree.center
        agreeLbl.alpha = 0
        view.addSubview(agreeLbl)
        reportLbl.text =  "Report"
        reportLbl.textColor = .white
        reportLbl.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        reportLbl.sizeToFit()
        reportLbl.center = agree.center
        
        view.addSubview(reportLbl)
        reportLbl.alpha = 0
        
        disagreeLbl.text =  "Disagree"
        disagreeLbl.textColor = .black
        disagreeLbl.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        disagreeLbl.sizeToFit()
        disagreeLbl.center = disagree.center
        disagreeLbl.alpha = 0
        view.addSubview(disagreeLbl)
        
        conditionLbl.text =  "Not yet tested"
        conditionLbl.textColor = UIColor(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
        conditionLbl.font = UIFont(name: "Montserrat-Bold", size: 15)
        conditionLbl.frame.size.width = 300
        conditionLbl.frame.size.height = 100
        conditionLbl.alpha = 0
        
        conditionLbl.center.y = not.center.y + 1000
        
        view.addSubview(conditionLbl)
        let tap = UITapGestureRecognizer(target: self, action: #selector(notTap))
        
        not.addGestureRecognizer(tap)
        
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(negTap))
        
        neg.addGestureRecognizer(tap2)
        
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(posTap))
        
        pos.addGestureRecognizer(tap3)
        
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(agreed))
        
        agree.addGestureRecognizer(tap4)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func agreed() {
        agreeCount += 1
        if agreeCount == 1{
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           options: [],
                           animations: { [weak self] in
                            self!.report.center.y = self!.report.center.y - 750
                            self!.report.fadeInV(2.0)
                            
                            self!.reportLbl.center.y = self!.reportLbl.center.y - 750
                            self!.reportLbl.fadeInL(2.0)
                            
                            
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.1,
                           options: [],
                           animations: { [weak self] in
                            
                            self!.terms.center.y = self!.terms.center.y - 1000
                            self!.terms.fadeIn(2.0)
                }, completion: nil)
        }
        
    }
    
    @objc func notTap() {
        condition = "not tested"
        step += 1
        if step == 1{
            UIView.animate(withDuration: 1.0,
                           delay: 1.2,
                           options: [],
                           animations: { [weak self] in
                            self!.confirm.center.y = self!.confirm.center.y - 1000
                            self!.q2.center.y = self!.view.center.y - 120
                            self!.q1.fadeOut(1.0)
                            
                            self!.agree.center.y = self!.agree.center.y - 950
                            self!.disagree.center.y = self!.disagree.center.y - 950
                            
                            self!.agreeLbl.center.y = self!.agreeLbl.center.y - 950
                            self!.disagreeLbl.center.y = self!.disagreeLbl.center.y - 950
                            
                            self!.agree.fadeInV(2.6)
                            self!.disagree.fadeInV(2.6)
                            
                            self!.agreeLbl.fadeInL(2.6)
                            self!.disagreeLbl.fadeInL(2.6)
                            self!.confirm.fadeInV(2.0)
                            self!.conditionLbl.fadeInV(2.0)
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                
                                self!.conditionLbl.text = "Please confirm that you have \(self!.condition)"
                                self!.conditionLbl.isEditable = false
                                self!.conditionLbl.sizeToFit()
                                self!.conditionLbl.center.x = self!.view.center.x - 11
                            }
                            
                            
                            self!.conditionLbl.center.y = self!.view.center.y - 35
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                }, completion: nil)
            
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.2,
                           options: [],
                           animations: { [weak self] in
                            
                            self!.posLbl.center.y = self!.q2.center.y + 100
                            
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.3,
                           options: [],
                           animations: { [weak self] in
                            
                            self!.q1.center.y = self!.q1.center.y + 1000
                            
                            
                            
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.2,
                           options: [],
                           animations: { [weak self] in
                            self!.not.center.y = self!.q1.center.y + 125
                            
                            self!.notLbl.center.y = self!.q1.center.y + 125
                            
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.1,
                           options: [],
                           animations: { [weak self] in
                            self!.neg.center.y = self!.not.center.y + 125
                            
                            self!.negLbl.center.y = self!.not.center.y + 125
                            
                            
                            
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           options: [],
                           animations: { [weak self] in
                            self!.pos.center.y = self!.pos.center.y + 700
                            self!.posLbl.center.y = self!.posLbl.center.y + 700
                            
                            
                            self!.timePicker.frame = CGRect(x: 0.0, y: 1000, width: self!.view.frame.width, height: 150.0)
                            
                }, completion: nil)
            
        }
        
        
    }
    
    
    @objc func negTap() {
        condition = "tested negative"
        UIView.animate(withDuration: 1.0,
                       delay: 1.2,
                       options: [],
                       animations: { [weak self] in
                        self!.confirm.center.y = self!.confirm.center.y - 1000
                        self!.q2.center.y = self!.view.center.y - 120
                        self!.q1.fadeOut(1.0)
                        
                        self!.agree.center.y = self!.agree.center.y - 950
                        self!.disagree.center.y = self!.disagree.center.y - 950
                        
                        self!.agreeLbl.center.y = self!.agreeLbl.center.y - 950
                        self!.disagreeLbl.center.y = self!.disagreeLbl.center.y - 950
                        
                        self!.agree.fadeInV(2.6)
                        self!.disagree.fadeInV(2.6)
                        
                        self!.agreeLbl.fadeInL(2.6)
                        self!.disagreeLbl.fadeInL(2.6)
                        self!.confirm.fadeInV(2.0)
                        self!.conditionLbl.fadeInV(2.0)
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            self!.conditionLbl.text = "Please confirm that you have \(self!.condition)"
                            self!.conditionLbl.isEditable = false
                            self!.conditionLbl.sizeToFit()
                            self!.conditionLbl.center.x = self!.view.center.x - 11
                        }
                        
                        
                        self!.conditionLbl.center.y = self!.view.center.y - 35
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
            }, completion: nil)
        
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.2,
                       options: [],
                       animations: { [weak self] in
                        
                        self!.posLbl.center.y = self!.q2.center.y + 100
                        
            }, completion: nil)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.3,
                       options: [],
                       animations: { [weak self] in
                        
                        self!.q1.center.y = self!.q1.center.y + 1000
                        
                        
                        
            }, completion: nil)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.2,
                       options: [],
                       animations: { [weak self] in
                        self!.not.center.y = self!.q1.center.y + 125
                        
                        self!.notLbl.center.y = self!.q1.center.y + 125
                        
            }, completion: nil)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.1,
                       options: [],
                       animations: { [weak self] in
                        self!.neg.center.y = self!.not.center.y + 125
                        
                        self!.negLbl.center.y = self!.not.center.y + 125
                        
                        
                        
            }, completion: nil)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [],
                       animations: { [weak self] in
                        self!.pos.center.y = self!.pos.center.y + 700
                        self!.posLbl.center.y = self!.posLbl.center.y + 700
                        
                        
                        self!.timePicker.frame = CGRect(x: 0.0, y: 1000, width: self!.view.frame.width, height: 150.0)
                        
            }, completion: nil)
        
    }
    
    
    
    
    
    @objc func posTap() {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        step += 1
        condition = "tested positive"
        if step == 1 {
            UIView.animate(withDuration: 1.0,
                           delay: 0.3,
                           options: [],
                           animations: { [weak self] in
                            
                            
                            self!.q1.center.y = self!.q1.center.y + 1000
                            self!.q1.fadeOut(1.0)
                            
                            
                            
                            
                }, completion: nil)
            
            
            
            
            
            
            
            
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.2,
                           options: [],
                           animations: { [weak self] in
                            self!.not.center.y = self!.q1.center.y + 125
                            
                            self!.notLbl.center.y = self!.q1.center.y + 125
                            self!.notLbl.fadeOutL(1.0)
                            self!.not.fadeOutV(1.0)
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.1,
                           options: [],
                           animations: { [weak self] in
                            self!.neg.center.y = self!.not.center.y + 125
                            
                            self!.negLbl.center.y = self!.not.center.y + 125
                            self!.neg.fadeOutV(1.0)
                            self!.negLbl.fadeOutL(1.0)
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           options: [],
                           animations: { [weak self] in
                            self!.pos.center.y = self!.neg.center.y + 125
                            self!.posLbl.center.y = self!.neg.center.y + 125
                            self!.posLbl.fadeOutL(1.0)
                            self!.pos.fadeOutV(1.0)
                }, completion: nil)
            
            
            UIView.animate(withDuration: 1.0,
                           delay: 1.0,
                           options: [],
                           animations: { [weak self] in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {                                          self!.posLbl.text = "Select Date"
                                self!.pos.center.y = self!.q1.center.y + 125
                                self!.posLbl.center.y = self!.q1.center.y + 125
                                
                                
                                self!.posLbl.sizeToFit()
                                self!.posLbl.center.x = self!.view.center.x
                                self!.posLbl.fadeInL(2.6)
                                self!.pos.fadeInV(2.6)
                                self!.q1.fadeIn(2.6)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self!.q1.text = "When did your symptoms start?"
                                self!.q1.sizeToFit()
                                self!.q1.center.x = self!.view.center.x - 45
                                
                                
                            }
                            
                            
                            
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 1.1,
                           options: [],
                           animations: { [weak self] in
                            
                            self!.q1.center.y = self!.q1.center.y - 1000
                            
                            
                            
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 1.2,
                           options: [],
                           animations: { [weak self] in
                            
                            self!.pos.center.y = self!.pos.center.y - 1000
                            
                            self!.posLbl.center.y = self!.posLbl.center.y - 1000
                            
                            
                            
                }, completion: nil)
        }
        if step == 2 {
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           options: [],
                           animations: { [weak self] in
                            
                            
                            self!.timePicker.frame = CGRect(x: 0.0, y: (self!.view.frame.height/2 + 60), width: self!.view.frame.width, height: 150.0)
                            
                            self!.timePicker.fadeInD(1.0)
                }, completion: nil)
            
        }
        if step == 3 {
            UIView.animate(withDuration: 1.0,
                           delay: 1.2,
                           options: [],
                           animations: { [weak self] in
                            self!.confirm.center.y = self!.confirm.center.y - 1000
                            self!.q2.center.y = self!.view.center.y - 120
                            self!.q1.fadeOut(1.0)
                            
                            self!.agree.center.y = self!.agree.center.y - 950
                            self!.disagree.center.y = self!.disagree.center.y - 950
                            
                            self!.agreeLbl.center.y = self!.agreeLbl.center.y - 950
                            self!.disagreeLbl.center.y = self!.disagreeLbl.center.y - 950
                            
                            self!.agree.fadeInV(2.6)
                            self!.disagree.fadeInV(2.6)
                            
                            self!.agreeLbl.fadeInL(2.6)
                            self!.disagreeLbl.fadeInL(2.6)
                            self!.confirm.fadeInV(2.0)
                            
                            
                            self!.conditionLbl.fadeInV(2.0)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                
                                self!.conditionLbl.text = "Please confirm that you have \(self!.condition)"
                                self!.conditionLbl.isEditable = false
                                self!.conditionLbl.sizeToFit()
                                self!.conditionLbl.center.x = self!.view.center.x - 11
                            }
                            
                            
                            self!.conditionLbl.center.y = self!.view.center.y - 35
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                }, completion: nil)
            
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.2,
                           options: [],
                           animations: { [weak self] in
                            
                            self!.posLbl.center.y = self!.q2.center.y + 100
                            
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.3,
                           options: [],
                           animations: { [weak self] in
                            
                            self!.q1.center.y = self!.q1.center.y + 1000
                            
                            
                            
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.2,
                           options: [],
                           animations: { [weak self] in
                            self!.not.center.y = self!.q1.center.y + 125
                            
                            self!.notLbl.center.y = self!.q1.center.y + 125
                            
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.1,
                           options: [],
                           animations: { [weak self] in
                            self!.neg.center.y = self!.not.center.y + 125
                            
                            self!.negLbl.center.y = self!.not.center.y + 125
                            
                            
                            
                }, completion: nil)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           options: [],
                           animations: { [weak self] in
                            self!.pos.center.y = self!.pos.center.y + 700
                            self!.posLbl.center.y = self!.posLbl.center.y + 700
                            
                            
                            self!.timePicker.frame = CGRect(x: 0.0, y: 1000, width: self!.view.frame.width, height: 150.0)
                            
                }, completion: nil)
            
        }
        
        
    }
}
extension UITextView {
    func fadeTo(_ alpha: CGFloat, duration: TimeInterval = 0.3) {
        DispatchQueue.main.async {
            UITextView.animate(withDuration: duration) {
                self.alpha = alpha
            }
        }
    }
    
    func fadeIn(_ duration: TimeInterval = 0.3) {
        fadeTo(1.0, duration: duration)
    }
    
    func fadeOut(_ duration: TimeInterval = 0.3) {
        fadeTo(0.0, duration: duration)
    }
}
extension UIView {
    func fadeToV(_ alpha: CGFloat, duration: TimeInterval = 0.3) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration) {
                self.alpha = alpha
            }
        }
    }
    
    func fadeInV(_ duration: TimeInterval = 0.3) {
        fadeToV(1.0, duration: duration)
    }
    
    func fadeOutV(_ duration: TimeInterval = 0.3) {
        fadeToV(0.0, duration: duration)
    }
}

extension UILabel {
    func fadeToL(_ alpha: CGFloat, duration: TimeInterval = 0.3) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration) {
                self.alpha = alpha
            }
        }
    }
    
    func fadeInL(_ duration: TimeInterval = 0.3) {
        fadeToL(1.0, duration: duration)
    }
    
    func fadeOutL(_ duration: TimeInterval = 0.3) {
        fadeToL(0.0, duration: duration)
    }
}
extension UIDatePicker {
    func fadeToD(_ alpha: CGFloat, duration: TimeInterval = 0.3) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration) {
                self.alpha = alpha
            }
        }
    }
    
    func fadeInD(_ duration: TimeInterval = 0.3) {
        fadeToD(1.0, duration: duration)
    }
    
    func fadeOutD(_ duration: TimeInterval = 0.3) {
        fadeToD(0.0, duration: duration)
    }
}
