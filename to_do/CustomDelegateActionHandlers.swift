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
    func addAlarmClicked(_ addAction: Bool) {
        let colorAlarmSelectionView = mainViewController.colorAlarmSelectionView
        let alarmDateChoosingView = mainViewController.alarmDateChoosingView
        let refreshView = mainViewController.refreshView
        var alarms = mainViewController.currentWorkingAlarms
        
        if addAction {
            if alarms.count <= 3 {
                if colorAlarmSelectionView?.alarmAddButtonToggle == false {
                    print("colorAlarmSelectionView?.alarmAddButtonToggle == false")
                    refreshView.titleField.endEditing(true)
                    mainViewController.alarmdate = (alarmDateChoosingView?.getAlarmDate())! as Date
                    let y = colorAlarmSelectionView!.frame.origin.y + colorAlarmSelectionView!.frame.size.height - 5
                    UIView.animate(withDuration: 0.35, animations: {
                        self.mainViewController.alarmDateChoosingView?.frame.origin.y = y
                    })
                }
                else {
                    print("colorAlarmSelectionView?.alarmAddButtonToggle == true")
                    refreshView.titleField.resignFirstResponder()
                    refreshView.titleField.endEditing(true)
                    mainViewController.alarmdate = (alarmDateChoosingView?.getAlarmDate())! as Date
                    let y = colorAlarmSelectionView!.frame.origin.y + colorAlarmSelectionView!.frame.size.height - 5
                    UIView.animate(withDuration: 0.35, animations: {
                        self.mainViewController.alarmDateChoosingView?.frame.origin.y = y
                    })
                    
                    alarmDateChoosingView?.delegate = self
                }
            }
        }
        else {
            if alarms.count <= 3 {
                //delete alarm
                let alarmIndexSelected = colorAlarmSelectionView?.getcurrentSelectedAlarmIndexArray()
//                                    print("alarmIndexSlected   :  ",alarmIndexSelected)
                
                if ((colorAlarmSelectionView?.alarmAddButtonToggle)! == false && alarmIndexSelected! ){
                    let alert = UIAlertController(title: "박사장님 짱", message: "지울꺼야 ㅜㅜ", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let yesAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
                        colorAlarmSelectionView?.alarmCount = (colorAlarmSelectionView?.alarmCount)! - 1
                        
                        let currentSelectedAlarmIndex = colorAlarmSelectionView?.getcurrentSelectedAlarmIndex()
                        
                        switch currentSelectedAlarmIndex! {
                        case 0 :
                            colorAlarmSelectionView?.firstAlarmBack.layer.borderColor = UIColor.gray.cgColor
                        case 1 :
                            colorAlarmSelectionView?.secondAlarmBack.layer.borderColor = UIColor.gray.cgColor
                        case 2 :
                            colorAlarmSelectionView?.thirdAlarmBack.layer.borderColor = UIColor.gray.cgColor
                        default:
                            print("Out of Range")
                        }
            
                        colorAlarmSelectionView?.selectedAlarmArray[currentSelectedAlarmIndex! + 1] = false
                        
                        refreshView.titleField.becomeFirstResponder()
                        
                        alarms.remove(at: currentSelectedAlarmIndex!)
                        print("after deleting alarm list\n \(alarms)")
                    }
                    
                    let noAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in }
                    
                    alert.addAction(yesAction)
                    alert.addAction(noAction)
                    self.mainViewController.present(alert, animated: true, completion: nil)
                }
                else{
                    refreshView.titleField.becomeFirstResponder()
                }
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
//        print("currentSelectedAlarmIndex?[alarmIndex]  : " , currentSelectedAlarmIndex?[alarmIndex])
//        print("alarm Index = \(alarmIndex)")
        
        let newAlarm = mainViewController.currentWorkingStartingDate.addingTimeInterval(TimeInterval(interval))
        mainViewController.currentWorkingAlarms.append(newAlarm)

        print("alarms list\n \(mainViewController.currentWorkingAlarms)")
    }
    
    func alarmSelectionClicked(_ alarmIndex: Int, appear: Bool) {
        let colorAlarmSelectionView = mainViewController.colorAlarmSelectionView
        let alarmDateChoosingView = mainViewController.alarmDateChoosingView
        let refreshView = mainViewController.refreshView
        
        if appear {
            refreshView.titleField.endEditing(true)
            self.mainViewController.alarmdate = (alarmDateChoosingView?.getAlarmDate())! as Date
            let y = colorAlarmSelectionView!.frame.origin.y + colorAlarmSelectionView!.frame.size.height - 5
            UIView.animate(withDuration: 0.35, animations: {
                self.mainViewController.alarmDateChoosingView?.frame.origin.y = y
            })
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
        
        let textFieldText = refreshView.getTitleText()

        if (textFieldText != "null") {
            if textFieldText.replacingOccurrences(of: " ", with: "") != "" {
                let newItem = CoreDataController.sharedInstace.saveToCoredata(title: textFieldText,
                                                                              startingDate: startingDate,
                                                                              alarms: alarms,
                                                                              colorIndex: colorIndex,
                                                                              color: color)
                mainViewController.dolist.append(newItem)
                mainViewController.tableView.reloadData()
            }
        }
        
        mainViewController.refreshView.titleField.text = ""
        mainViewController.dismissRefreshControl()
    }

}
