//
//  AddSubInfo.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/25/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit

class AddSubInfo: UIView {

    @IBOutlet weak var testButton: UIButton!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.å
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var keyboardHeight:CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
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
    func keyboardWillShow(nofification : NSNotification){
        let userInfo:NSDictionary = nofification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        self.keyboardHeight = keyboardRectangle.height
        
        
        print("test position y : " + String(testButton.frame.origin.y))
        testButton.center = CGPointMake(100, 150)
        print("test position y : " + String(testButton.frame.origin.y))
    
        
        print("keyboard 11: \(keyboardHeight)")
        
        
    }

}
