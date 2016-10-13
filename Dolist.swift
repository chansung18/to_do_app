//
//  Dolist.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/13/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import Foundation
import CoreData


class Dolist: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
//    init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?,
//        title: String, deadline: NSDate, addingHours: Int, addingMinutes: Int) {
//        
//        super.init(entity: entity, insertIntoManagedObjectContext: context)
//        
//        self.title = title
//        self.deadline = deadline
//        
//        print(deadline)
//        let secondsInHours = Double(addingHours) * 60 * 60
//        let secondsInMinutes = Double(addingMinutes) * 60
//        
//        self.deadline = self.deadline!.dateByAddingTimeInterval(secondsInHours + secondsInMinutes)
//        print(self.deadline)
//    }

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        startingDate = Date()
        
    }
    
    //날짜정하기
    func addAlarm(_ when: Date, addingAlarmHours: Int, addingAlarmMinutes: Int) {
        let secondsInHours = Double(addingAlarmHours) * 60 * 60
        let secondsInMinutes = Double(addingAlarmMinutes) * 60
        let newAlarm = when.addingTimeInterval(secondsInHours + secondsInMinutes)
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Alarm",
                                                                  in: CoreDataController.sharedInstace.managedObjectContext)
        let itemObject = Alarm(entity: entityDescription!,
                               insertInto: CoreDataController.sharedInstace.managedObjectContext)
        itemObject.alarm = newAlarm
        itemObject.dolist = self
        
        let copy = NSMutableSet.init(set: self.alarms!)
        copy.add(itemObject)
        self.alarms = copy
        
        CoreDataController.sharedInstace.saveContext()
    }
    
    //날짜로 부터 D-Day
    func addAlarmForDday(_ whenToDays: Int, addingAlarmHours: Int, addingAlarmMinutes: Int) {
        let secondsInDays = Double(whenToDays) * 24 * 60 * 60
        let secondsInHours = Double(addingAlarmHours) * 60 * 60
        let secondsInMinutes = Double(addingAlarmMinutes) * 60
        let newAlarm = self.startingDate!.addingTimeInterval(secondsInDays + secondsInHours + secondsInMinutes)
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Alarm",
                                                                  in: CoreDataController.sharedInstace.managedObjectContext)
        let itemObject = Alarm(entity: entityDescription!,
                               insertInto: CoreDataController.sharedInstace.managedObjectContext)
        itemObject.alarm = newAlarm
        itemObject.dolist = self
        
        let copy = NSMutableSet.init(set: self.alarms!)
        copy.add(itemObject)
        self.alarms = copy
        
        CoreDataController.sharedInstace.saveContext()
    }
}
