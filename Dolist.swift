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

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        startingDate = NSDate()
    }
    
    //날짜정하기
    func addAlarm(when: NSDate, addingAlarmHours: Int, addingAlarmMinutes: Int) {
        let secondsInHours = Double(addingAlarmHours) * 60 * 60
        let secondsInMinutes = Double(addingAlarmMinutes) * 60
        let newAlarm = when.dateByAddingTimeInterval(secondsInHours + secondsInMinutes)
        self.alarms?.setValue(newAlarm, forKey: newAlarm.description)
//        self.alarms.append(newAlarm)
    }
    
    //날짜로 부터 D-Day
    func addAlarmForDday(whenToDays: Int, addingAlarmHours: Int, addingAlarmMinutes: Int) {
        let secondsInDays = Double(whenToDays) * 24 * 60 * 60
        let secondsInHours = Double(addingAlarmHours) * 60 * 60
        let secondsInMinutes = Double(addingAlarmMinutes) * 60
        let newAlarm = self.startingDate!.dateByAddingTimeInterval(secondsInDays + secondsInHours + secondsInMinutes)
        self.alarms?.setValue(newAlarm, forKey: newAlarm.description)
        print("set value :  "  + String(newAlarm))
//        self.alarms.append(newAlarm)
    }
    func loadAlarms(){
        print("before  loop :  " + String(self.alarms))
        for alarm in (self.alarms!){
            print("in the loop")
            print("\n \n \n \n alarm   :  " + String(alarm))
        }
    }
}
