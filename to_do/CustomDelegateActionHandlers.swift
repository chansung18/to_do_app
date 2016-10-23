//
//  CustomDelegateActionHandlers.swift
//  to_do
//
//  Created by chansung on 10/18/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CustomDelegateActionHandlers: AddSubInfoDelegate,
                                    AlarmSubinfoDelegate,
                                    AddTodoItemDelegate {
    
    let mainViewController: ViewController!
    
    init(viewController: ViewController) {
        self.mainViewController = viewController
    }

    /*
     AddSubInfoDelegate Methods
     - addAlarmClicked(_ addAction: Bool)
     - confirmAlarmClicked(alarmInfoView: AddSubInfo, alarmIndex: Int)
     - colorSelectionClicked(colorIndex: Int, color: UIColor)
     - alarmSelectionClicked(_ alarmIndex: Int, appear: Bool)
    */
    func addAlarmClicked(addSubInfoView: AddSubInfo, addAction: Bool, isNewAlarmSelected: Bool, alarmIndex: Int) {
        let colorAlarmSelectionView = mainViewController.colorAlarmSelectionView
        let refreshView = mainViewController.refreshView
        var alarms = mainViewController.currentWorkingAlarms
        
        if addAction {
            mainViewController.alarmDateChoosingView?.day = 0
            mainViewController.alarmDateChoosingView?.hour = 0
            mainViewController.alarmDateChoosingView?.minute = 0
            
            mainViewController.showAlarmDateChoosingView()
        }
        else {
            /* when tring to delete existing alarm */
            if !isNewAlarmSelected {
                let alert = UIAlertController(title: "박사장님 짱",
                                              message: "지울꺼야 ㅜㅜ",
                                              preferredStyle: UIAlertControllerStyle.alert)

                let yesAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
                    refreshView.titleField.becomeFirstResponder()

                    alarms.remove(at: alarmIndex)
                    colorAlarmSelectionView?.alarmCount -= 1
                    colorAlarmSelectionView?.currentSelectedAlarmIndex = -1
                    
                    self.mainViewController.currentWorkingAlarms = alarms
                    addSubInfoView.alarmAddButtonToggle = false
                    addSubInfoView.isNewAlarmSelected = true
                }

                let noAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
                    colorAlarmSelectionView?.alarmAddButtonToggle = true
                }

                alert.addAction(yesAction)
                alert.addAction(noAction)
                mainViewController.present(alert, animated: true, completion: nil)
            }
            else {
                refreshView.titleField.becomeFirstResponder()
            }
        }
    }
    
    func confirmAlarmClicked(alarmInfoView: AddSubInfo, alarmIndex: Int) {
        print("confirmAlarmClicked index = \(alarmIndex)")
        
        let alarmDateChoosingView = mainViewController.alarmDateChoosingView
        let refreshView = mainViewController.refreshView
        
        let day = alarmDateChoosingView!.day * 24 * 60 * 60
        let hour = alarmDateChoosingView!.hour * 60 * 60
        let minute = alarmDateChoosingView!.minute * 60
        let interval = day + hour + minute
        var existingAlarmFlag : Bool = false
        let newAlarm = mainViewController.currentWorkingStartingDate.addingTimeInterval(TimeInterval(interval))
   
        //when inputing 0 interval alarm
        if day == 0 && hour == 0 && minute == 0 {
            let alertController = UIAlertController(title: "Zero Alarm",
                                                    message: "No Interval Input",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                refreshView.titleField.becomeFirstResponder()
            }))
                
            mainViewController.present(alertController, animated: true, completion: nil)
        }
        else {
            //when inputing same alarm
            for oldAarm in mainViewController.currentWorkingAlarms{
                let interval = oldAarm.timeIntervalSince(newAlarm)
                
                if (interval == 0){
                    existingAlarmFlag = true
                }
            }
            
            if !existingAlarmFlag {
                refreshView.titleField.becomeFirstResponder()
                
                if alarmIndex == -1 {
                    mainViewController.currentWorkingAlarms.append(newAlarm)
                }
                else {
                    mainViewController.currentWorkingAlarms[alarmIndex] = newAlarm
                }

                print("alarms list\n \(mainViewController.currentWorkingAlarms)")
            }
            else {
                let alertController = UIAlertController(title: "Duplicate Alarm",
                                                        message: "Same Alarm Date Not Allowed",
                                                        preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                    refreshView.titleField.becomeFirstResponder()
                }))
                mainViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func alarmSelectionClicked(alarmIndex: Int, appear: Bool) {
        let startingDate = mainViewController.currentWorkingStartingDate
        let alarms = mainViewController.currentWorkingAlarms
        let alarm = alarms[alarmIndex]
        let refreshView = mainViewController.refreshView
        
        if appear {
            mainViewController.showAlarmDateChoosingView()
            
            let interval = alarm.timeIntervalSince(startingDate)
            let d = div(Int32(interval), 86400);
            let h = div(d.rem, 3600);
            let m = div(h.rem, 60);
            
            mainViewController.alarmDateChoosingView?.day = Int(d.quot)
            mainViewController.alarmDateChoosingView?.hour = Int(h.quot)
            mainViewController.alarmDateChoosingView?.minute = Int(m.quot)
        }
        else {
            refreshView.titleField.becomeFirstResponder()
        }
    }
    
    func colorSelectionClicked(colorIndex: Int, color: UIColor) {
        mainViewController.currentWorkingColorIndex = colorIndex
        mainViewController.currentWorkingColor = color
    }

    /*
     AlarmSubinfoDelegate Methods
     - alarmChanged()
    */
    func alarmChanged() { }
    
    /*
     AddTodoItemDelegate Methods
     - toDoItemAddClicked()
    */
    func toDoItemAddClicked() {
        let refreshView = mainViewController.refreshView
        let color = mainViewController.currentWorkingColor
        let colorIndex = mainViewController.currentWorkingColorIndex
        let startingDate = mainViewController.currentWorkingStartingDate
        let alarms = mainViewController.currentWorkingAlarms
        let itemList = mainViewController.dolist
        
        print("new alarm size = \(alarms.count)")
        
        let textFieldText = refreshView.getTitleText()

        if textFieldText != "null" &&
            textFieldText.replacingOccurrences(of: " ", with: "") != "" {
            
            let result = isThereDuplicateItem(list: itemList, key: startingDate)
            
            if let item = result.item {
                let replacedItem = CoreDataController.sharedInstace.replaceToDoList(item: item, title: textFieldText, alarms: alarms, colorIndex: colorIndex, color: color)
                mainViewController.dolist[result.index] = replacedItem
            
            }
            else {
                let newItem = CoreDataController.sharedInstace.addToDoList(title: textFieldText,
                                                                           startingDate: startingDate,
                                                                           alarms: alarms,
                                                                           colorIndex: colorIndex,
                                                                           color: color)
                mainViewController.dolist.append(newItem)
            }

            mainViewController.tableView.reloadData()
        }
        
        mainViewController.refreshView.titleField.text = ""
        mainViewController.dismissRefreshControl()
    }

    func isThereDuplicateItem(list: [Dolist], key: Date) -> (item: Dolist?, index: Int) {
        for index in 0..<list.count {
            if list[index].startingDate == key {
                return (list[index], index)
            }
        }
    
        return (nil, -1)
    }
}
