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
    
    func saveToCoredata(title: String, startingDate: Date, alarms: [Date], colorIndex: Int, color: UIColor) -> Dolist {
        let doListEntityDescription = NSEntityDescription.entity(forEntityName: "Dolist", in: managedObjectContext)
        let doListObject = Dolist(entity: doListEntityDescription!, insertInto: managedObjectContext)
        
        let colorDescription = NSEntityDescription.entity(forEntityName: "Color", in: managedObjectContext)
        let colorObject = Color(entity: colorDescription!, insertInto: managedObjectContext)
        
        doListObject.title = title
        doListObject.startingDate = startingDate
        
        let coreImageColor = CoreImage.CIColor(color: color)
        colorObject.r = (coreImageColor.red * 256) as NSNumber!
        colorObject.g = (coreImageColor.green * 256) as NSNumber!
        colorObject.b = (coreImageColor.blue * 256) as NSNumber!
        colorObject.a = NSNumber(integerLiteral: 1)
        colorObject.index = colorIndex as NSNumber!
        doListObject.color = colorObject
        
        for alarm in alarms {
            let alarmDescription = NSEntityDescription.entity(forEntityName: "Alarm", in: managedObjectContext)
            let alarmObject = Alarm(entity: alarmDescription!, insertInto: managedObjectContext)
            alarmObject.alarm = alarm
            
            if let alarmsInDoList = doListObject.alarms {
                let tmpAlarmsInDoList = NSMutableSet(set: alarmsInDoList)
                tmpAlarmsInDoList.addObjects(from: [alarmObject])
                doListObject.alarms = tmpAlarmsInDoList
            }
        }
        
        saveContext()
        return doListObject
    }
    
    func loadFromCoredata() -> [Dolist]{
        var dolist = [Dolist]()
        
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
