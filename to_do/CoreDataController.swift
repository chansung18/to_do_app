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
    
    //singleton constatant instance
    static let sharedInstace = CoreDataController()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    //private init for singleton class
    fileprivate init() {}
    
    func saveToCoredata(_ title: String, deadline: Date, color: Color) -> Dolist {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Dolist", in: managedObjectContext)
        let itemObject = Dolist(entity: entityDescription!, insertInto: managedObjectContext)
        
        itemObject.title = title
        itemObject.deadline = deadline
        itemObject.color = color

        saveContext()
        
        //test - adding alarm
        itemObject.addAlarmForDday(1, addingAlarmHours: 1, addingAlarmMinutes: 1)
        itemObject.addAlarmForDday(2, addingAlarmHours: 1, addingAlarmMinutes: 1)
        
        return itemObject
    }
    
    func loadFromCoredata() -> [Dolist]{
        var dolist = [Dolist]()
      //  let request = NSFetchRequest(entityName: "Dolist")
        var request : NSFetchRequest<NSFetchRequestResult>?
        if #available(iOS 10.0, *) {
             request  = Dolist.fetchRequest()
        } else {
            // Fallback on earlier versions
             request = nil;
        }
        let error :NSError? = nil
        do {
            try dolist = managedObjectContext.fetch(request!) as! [Dolist]
        }
        catch {error}
        
        if error != nil {
            print("Error : " + String(describing: error))
        }
        else {
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
    
    func removeFromCoreData(_ doItem: Dolist) {
        managedObjectContext.delete(doItem)
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
            print("Error : " + String(describing: error))
        }
        else {
            print("saved")
        }
    }
}
