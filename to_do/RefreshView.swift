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
        let view = NSBundle.mainBundle().loadNibNamed("RefreshView", owner: self, options: nil).first as! UIView
        view.frame = bounds
        addSubview(view)
        titleField.autocorrectionType = UITextAutocorrectionType.No
    }
    func getTitleText() -> String {
        if (textFieldText != nil) {
            return textFieldText!
        }
        else{
            return "null"
        }
    }
    
    @IBAction func whenPressComfirm(sender: AnyObject) {
        print("delegate action")
        textFieldText = titleField.text
        delegate?.toDoItemAddClicked()
        titleField.endEditing(true)
        
        
        /*print("whenPressComfirm")
         mainViewController?.dismissRefreshControl()
         
         let formatter = NSDateFormatter()
         formatter.dateFormat = "yyyy'-'MM'-'dd HH:mm:ss"
         let someDate = formatter.dateFromString("2014-12-25 10:25:00")
         print("somdate  : " + String(someDate))
         
         let colorR = arc4random() % 256
         let colorG = arc4random() % 256
         let colorB = arc4random() % 256
         
         let entityDescription = NSEntityDescription.entityForName("Color",
         inManagedObjectContext: CoreDataController.sharedInstace.managedObjectContext)
         let color = Color(entity: entityDescription!,
         insertIntoManagedObjectContext: CoreDataController.sharedInstace.managedObjectContext)
         color.r = NSNumber(unsignedInt: colorR)
         color.g = NSNumber(unsignedInt: colorG)
         color.b = NSNumber(unsignedInt: colorB)
         color.a = NSNumber(unsignedInt: colorB)
         
         if let textFieldText = titleField.text {
         if textFieldText.stringByReplacingOccurrencesOfString(" ", withString: "") != "" {
         let newItem = CoreDataController.sharedInstace.saveToCoredata(textFieldText, deadline: someDate!, color: color)
         mainViewController?.dolist.append(newItem)
         mainViewController?.tableView.reloadData()
         titleField.endEditing(true)
         }
         else {
         print("textFieldText = empty")
         }
         }
         else {
         print("textFieldText = nil")
         }*/
    }
}
