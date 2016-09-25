//
//  AddSubInfo.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/25/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit

class AddSubInfo: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInitialization()
    }
    
    func commonInitialization() {
        let view = NSBundle.mainBundle().loadNibNamed("AddSubInfo", owner: self, options: nil).first as! UIView
        view.frame = bounds
        addSubview(view)
    }
    

}
