//
//  RefreshView.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/22/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit

class RefreshView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInitialization()
    }
    
    func commonInitialization() {
        let view = NSBundle.mainBundle().loadNibNamed("CustomView", owner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }


}
