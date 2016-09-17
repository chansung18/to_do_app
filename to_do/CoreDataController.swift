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
    func saveToCoredata(doItem: ToDoItem) {
        
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
            //let myAlert = UIAlertView(title: "Error",message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Ok")
            //myAlert.show()
            print("Error : " + String(error))
        }else{
            //let myAlert = UIAlertView(title: "saved", message: "Infomation saved", delegate: nil, cancelButtonTitle: "Ok")
            //myAlert.show()
            print("saved")
        }
        
    }
    func loadFromCoredata() -> [Dolist]{
        var dolist = [Dolist]()
        let request = NSFetchRequest(entityName: "Dolist")
        
        var error :NSError?
        do {try dolist = managedObjectContext.executeFetchRequest(request) as! [Dolist]}
        catch{error}
        
        if let err = error{
            //let myAlert = UIAlertView(title: "Error",message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Ok")
            //myAlert.show()
            print("Error : " + String(error))
        
        }else{
            print("list  : " + String(dolist))
        }
        
        return dolist
    }
}
