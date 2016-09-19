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

class CoreDataController {
    
    static let sharedInstace = CoreDataController()
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    private init() { }
    
    func saveToCoredata(title: String, deadline: NSDate, color: Color) {
        
        let entityDescription = NSEntityDescription.entityForName("Dolist", inManagedObjectContext: managedObjectContext)
        let itemObject = Dolist(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        itemObject.title = title
//        itemObject.context = doItem.context
        itemObject.deadline = deadline
        itemObject.color = color
//        itemObject.decroration = doItem.decoration
        
        saveContext()
    }
    
    func loadFromCoredata() -> [Dolist]{
        var dolist = [Dolist]()
        let request = NSFetchRequest(entityName: "Dolist")
        
        let error :NSError? = nil
        do {try dolist = managedObjectContext.executeFetchRequest(request) as! [Dolist]}
        catch{error}
        
        if error != nil {
            //let myAlert = UIAlertView(title: "Error",message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Ok")
            //myAlert.show()
            print("Error : " + String(error))
        
        }else{
            print("list  : " + String(dolist))
        }
        
        return dolist
    }
    
    func removeFromCoreData(doItem: Dolist) {
        managedObjectContext.deleteObject(doItem)
        saveContext()
    }
    
    func saveContext() {
        let error :NSError? = nil
        do {
            try managedObjectContext.save()
        }
        catch {
            error
        }
        
        if error != nil {
            print("Error : " + String(error))
        }
        else {
            print("saved")
        }
    }
}
