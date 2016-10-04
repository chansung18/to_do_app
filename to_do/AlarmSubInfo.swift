//
//  AlarmSubInfo.swift
//  to_do
//
//  Created by chansung on 10/4/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit

class AlarmSubInfo: UIView {

    @IBOutlet weak var daycount2: UILabel!
    @IBOutlet weak var dayCount: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInitialization()
    }
    
    func commonInitialization() {
        let view = NSBundle.mainBundle().loadNibNamed("AlarmSubInfo", owner: self, options: nil).first as! UIView
        view.frame = bounds
        daycount2.text = "park lab"
//        dayCount.layer.cornerRadius = 10
//        dayCount.layer.masksToBounds = true
//        dayCount.layer.borderWidth = 2.0
//        dayCount.layer.borderColor = UIColor.grayColor().CGColor
        
        view.layer.cornerRadius = 15
        
        addSubview(view)
    }
}
