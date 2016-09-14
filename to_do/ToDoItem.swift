//
//  ToDoItem.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/13/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class ToDoItem{
    
    var title: String = "new item"
    var startingDate: NSDate = NSDate()
    var deadline: NSDate = NSDate()
    var alarms: [NSDate] = [NSDate]()
    var decoration:String?
    var context:String?
    //var calendar : NSCalendar
    
    //  let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    init(title: String, deadline: NSDate, addingHours: Int, addingMinutes: Int){
        self.title = title
        self.deadline = deadline
        
        print(deadline)
        let secondsInHours = Double(addingHours) * 60 * 60
        let secondsInMinutes = Double(addingMinutes) * 60
        
        self.deadline = self.deadline.dateByAddingTimeInterval(secondsInHours + secondsInMinutes)
        print(self.deadline)
    }
    
    //날짜정하기
    func addAlarm(when: NSDate, addingAlarmHours: Int, addingAlarmMinutes: Int) {
        let secondsInHours = Double(addingAlarmHours) * 60 * 60
        let secondsInMinutes = Double(addingAlarmMinutes) * 60
        let newAlarm = when.dateByAddingTimeInterval(secondsInHours + secondsInMinutes)
        print(newAlarm)
        self.alarms.append(newAlarm)
        
        
    }
    //날짜로 부터 D-Day
    func addAlarm(whenToDays: Int, addingAlarmHours: Int, addingAlarmMinutes: Int) {
        
        let secondsInDays = Double(whenToDays) * 24 * 60 * 60
        let secondsInHours = Double(addingAlarmHours) * 60 * 60
        let secondsInMinutes = Double(addingAlarmMinutes) * 60
        let newAlarm = self.startingDate.dateByAddingTimeInterval(secondsInDays + secondsInHours + secondsInMinutes)
        print(newAlarm)
        self.alarms.append(newAlarm)
    }
    func setContext(newContext: String){
        self.context = newContext
    }
    func getTitle() -> String{
        return self.title
    }
    func getStartingDate()->NSDate{
        return self.startingDate
    }
    func getDeadline()->NSDate{
        return self.deadline
    }
    func getAlarms() -> [NSDate]{
        return self.alarms
    }
    func getContext() ->String?{
        return self.context
    }
    
    func showitem(){
        
        print("title : " + title + "   Date : " + String(self.deadline))
        print("aram" + String(self.alarms))
    }
    
    
}
