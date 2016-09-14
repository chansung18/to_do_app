//
//  CoreDataController.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/14/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataController{
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    init(){
        
        
    }
    func saveToCoredate(doItem: ToDoItem) {
        
        let entityDescription = NSEntityDescription.entityForName("Dolist", inManagedObjectContext: managedObjectContext)
        let itemObject = Dolist(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        itemObject.title = doItem.title
        itemObject.context = doItem.context
        itemObject.startingDate = doItem.startingDate
        itemObject.deadline = doItem.deadline
        itemObject.decration = doItem.decoration
        
        var error :NSError?
        do {try managedObjectContext.save()}
        catch{error}
        
        if let err = error{
            let myAlert = UIAlertView(title: "Error",message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Ok")
            myAlert.show()
        }else{
            let myAlert = UIAlertView(title: "saved", message: "Infomation saved", delegate: nil, cancelButtonTitle: "Ok")
            myAlert.show()
        }
        
    }
    
}
