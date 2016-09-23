//
//  RefreshView.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/22/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit

class RefreshView: UIView {
    
    @IBOutlet var textField: UIView!
    @IBOutlet weak var titleField: UITextField!
    var textFieldText:String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInitialization()
    }
    
    func commonInitialization() {
        let view = NSBundle.mainBundle().loadNibNamed("RefreshView", owner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    func getTitle()->String{
        return textFieldText!
    }

    @IBAction func whenPressComfirm(sender: AnyObject) {
        textFieldText = titleField.text
        
    }

}
