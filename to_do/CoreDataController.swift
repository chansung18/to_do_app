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
        
        //test
        itemObject.addAlarmForDday(1, addingAlarmHours: 1, addingAlarmMinutes: 1)
        itemObject.addAlarmForDday(2, addingAlarmHours: 1, addingAlarmMinutes: 1)
    }
    
    func loadFromCoredata() -> [Dolist]{
        var dolist = [Dolist]()
        let request = NSFetchRequest(entityName: "Dolist")
        
        let error :NSError? = nil
        do {
            try dolist = managedObjectContext.executeFetchRequest(request) as! [Dolist]
        }
        catch {error}
        
        if error != nil {
            //let myAlert = UIAlertView(title: "Error",message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Ok")
            //myAlert.show()
            print("Error : " + String(error))
        
        }
        else {
//            print("list  : " + String(dolist))
            for doItem in dolist {
                print("doItem : \(doItem.title)")
                
                for alarm in doItem.alarms! {
                    let a = alarm as! Alarm
                    print("alarm : \(a.alarm?.description)")
                }
            }
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
