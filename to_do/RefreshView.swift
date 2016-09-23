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
    
    var mainViewController: ViewController?
    
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
    
    @IBAction func whenPressComfirm(sender: AnyObject) {
        textFieldText = titleField.text
        print("whenPressComfirm")
        
        UIView.animateWithDuration(0.5) {
            if let cells = self.mainViewController?.tableView.visibleCells {
                for cell in cells {
                    cell.alpha = 1
                }
            }
        }
        
        self.mainViewController?.refreshController.endRefreshing()
    }

}
