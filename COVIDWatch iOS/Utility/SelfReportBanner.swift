//
//  SelfReportBanner.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/2/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class SelfReportBanner: UIView {

    @IBOutlet var thisView: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Bundle.main.loadNibNamed("SelfReportBanner", owner: self, options: nil)
        self.addSubview(self.thisView)
    }
    
//    let nibName = "SelfReportBanner"
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    func commonInit() {
//        guard let view = loadViewFromNib() else { return }
//        view.frame = self.bounds
//        self.addSubview(view)
//    }
//
//    func loadViewFromNib() -> UIView? {
//        let nib = UINib(nibName: nibName, bundle: nil)
//        return nib.instantiate(withOwner: self, options: nil).first as? UIView
//    }
    
}
