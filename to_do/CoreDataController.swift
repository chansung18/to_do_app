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
    
    func replaceToDoList(item: Dolist, title: String, alarms: [Date], colorIndex: Int, color: UIColor) -> Dolist {
        item.title = title
        
        let coreImageColor = CoreImage.CIColor(color: color)
        item.color!.r = (coreImageColor.red * 256) as NSNumber!
        item.color!.g = (coreImageColor.green * 256) as NSNumber!
        item.color!.b = (coreImageColor.blue * 256) as NSNumber!
        item.color!.a = NSNumber(integerLiteral: 1)
        item.color!.index = colorIndex as NSNumber!
        
        for alarm in item.alarms! {
            managedObjectContext.delete(alarm as! NSManagedObject)
        }
        
        let tmpAlarmsInDoList = NSMutableSet(set: item.alarms!)
        tmpAlarmsInDoList.removeAllObjects()
        item.alarms = tmpAlarmsInDoList
        
        print("item.alarms size = \(item.alarms!.count)")
        
        for alarm in alarms {
            /* Create Alarm CoreData Object */
            let alarmDescription = NSEntityDescription.entity(forEntityName: "Alarm", in: managedObjectContext)
            let alarmObject = Alarm(entity: alarmDescription!, insertInto: managedObjectContext)
            alarmObject.alarm = alarm
            
            let tmpAlarmsInDoList = NSMutableSet(set: item.alarms!)
            tmpAlarmsInDoList.addObjects(from: [alarmObject])
            item.alarms = tmpAlarmsInDoList
        }
        
        saveContext()
        return item
    }
    
    func addToDoList(title: String, startingDate: Date, alarms: [Date], colorIndex: Int, color: UIColor) -> Dolist {
        /* Create Dolist CoreData Object */
        let doListEntityDescription = NSEntityDescription.entity(forEntityName: "Dolist", in: managedObjectContext)
        let doListObject = Dolist(entity: doListEntityDescription!, insertInto: managedObjectContext)
        
        /* Create Color CoreData Object */
        let colorDescription = NSEntityDescription.entity(forEntityName: "Color", in: managedObjectContext)
        let colorObject = Color(entity: colorDescription!, insertInto: managedObjectContext)
        
        let coreImageColor = CoreImage.CIColor(color: color)
        colorObject.r = (coreImageColor.red * 256) as NSNumber!
        colorObject.g = (coreImageColor.green * 256) as NSNumber!
        colorObject.b = (coreImageColor.blue * 256) as NSNumber!
        colorObject.a = NSNumber(integerLiteral: 1)
        colorObject.index = colorIndex as NSNumber!
        
        doListObject.title = title
        doListObject.startingDate = startingDate
        doListObject.lineflag = NSNumber(value: false)
        doListObject.color = colorObject            // hooking up Dolist with Color CoreData Object (relation)
        
        for alarm in alarms {
            /* Create Alarm CoreData Object */
            let alarmDescription = NSEntityDescription.entity(forEntityName: "Alarm", in: managedObjectContext)
            let alarmObject = Alarm(entity: alarmDescription!, insertInto: managedObjectContext)
            alarmObject.alarm = alarm
            
            if let alarmsInDoList = doListObject.alarms {
                /*
                 datatype for alarms list in Dolist is NSSet
                 make the NSSet mutable to store alarms
                 */
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
        var request: NSFetchRequest<NSFetchRequestResult>?
        
        if #available(iOS 10.0, *) {
            request = Dolist.fetchRequest()
        } else {
            request = NSFetchRequest(entityName: "Dolist")
        }
        
        if let request = request {
            do {
                dolist = try managedObjectContext.fetch(request) as! [Dolist]
            }
            catch {
                fatalError("Error while loading dolist from coredata storage")
            }
        }
        
        if !dolist.isEmpty {
            //for doItem in dolist {
            //  do something to print or check if wanting to inspect dolist data
            //}
        }
        
        return dolist
    }
    
    func removeFromCoreData(_ doItem: Dolist) {
        managedObjectContext.delete(doItem)
        saveContext()
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        }
        catch {
            fatalError("Error while saving data into Coredata Storage")
        }
    }
}
