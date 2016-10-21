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

class CustomDelegateActionHandlers: ToDoListTableViewCellDelegate,
                                    AddSubInfoDelegate,
                                    AlarmSubinfoDelegate,
                                    AddTodoItemDelegate {
    
    let mainViewController: ViewController!
    
    init(viewController: ViewController) {
        self.mainViewController = viewController
    }
    
    func cellValueChanged(_ cell: ToDoListTableViewCell) {
        let index = cell.index
        
        mainViewController.dolist[index].title = cell.originalTitle
        mainViewController.dolist[index].lineflag = cell.isCrossedOut as NSNumber?
    }
    
    /*
     AddSubInfoDelegate Methods
     - addAlarmClicked(_ addAction: Bool)
     - confirmAlarmClicked(alarmInfoView: AddSubInfo, alarmIndex: Int)
     - colorSelectionClicked(colorIndex: Int, color: UIColor)
     - alarmSelectionClicked(_ alarmIndex: Int, appear: Bool)
    */
    func addAlarmClicked(addAction: Bool, isNewAlarmSelected: Bool, alarmIndex: Int) {
        let colorAlarmSelectionView = mainViewController.colorAlarmSelectionView
        let refreshView = mainViewController.refreshView
        var alarms = mainViewController.currentWorkingAlarms
        
        if addAction {
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
        let alarmDateChoosingView = mainViewController.alarmDateChoosingView
        let refreshView = mainViewController.refreshView
        var currentSelectedAlarmIndex = mainViewController.currentSelectedAlarmIndex
        
        if alarmIndex >= 3 {
            refreshView.titleField.becomeFirstResponder()
        }
        
        let day = alarmDateChoosingView!.day * 12 * 60 * 60
        let hour = alarmDateChoosingView!.hour * 60 * 60
        let minute = alarmDateChoosingView!.minute * 60
        let interval = day + hour + minute
        
        currentSelectedAlarmIndex?[alarmIndex] = 1
        
        let newAlarm = mainViewController.currentWorkingStartingDate.addingTimeInterval(TimeInterval(interval))
        mainViewController.currentWorkingAlarms.append(newAlarm)

        print("alarms list\n \(mainViewController.currentWorkingAlarms)")
    }
    
    func alarmSelectionClicked(alarmIndex: Int, appear: Bool) {
        let refreshView = mainViewController.refreshView
        
        if appear {
            mainViewController.showAlarmDateChoosingView()
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
