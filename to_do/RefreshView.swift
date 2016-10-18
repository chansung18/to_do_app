//
//  RefreshView.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/22/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit
import CoreData

protocol AddTodoItemDelegate {
    func toDoItemAddClicked()
}


class RefreshView: UIView {
    @IBOutlet weak var titleField: UITextField!
    
    var delegate: AddTodoItemDelegate?
    var textFieldText:String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInitialization()
    }
    
    func commonInitialization() {
        let view = Bundle.main.loadNibNamed("RefreshView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
        titleField.autocorrectionType = UITextAutocorrectionType.no
    }
    func getTitleText() -> String {
        if (textFieldText != nil) {
            return textFieldText!
        }
        else{
            return "null"
        }
    }
    
    @IBAction func whenPressComfirm(_ sender: AnyObject) {
        textFieldText = titleField.text
        delegate?.toDoItemAddClicked()
        titleField.endEditing(true)
    }
}
