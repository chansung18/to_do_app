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
        
        print("cellValueChanged is called on Cell Index \(index)")
        
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
        let keyboardSubView = mainViewController.keyboardSubView
        let keyboardAlarmSubView = mainViewController.keyboardAlarmSubView
        let subviewitem = mainViewController.subviewitem
        var alarms = mainViewController.currentWorkingAlarms
        
        if addAction {
            if alarms.count <= 3 {
                if keyboardSubView?.alarmAddButtonToggle == false {
                    print("keyboardSubView?.alarmAddButtonToggle == false")
                    subviewitem.titleField.endEditing(true)
                    mainViewController.alarmdate = (keyboardAlarmSubView?.getAlarmDate())! as Date
                    let y = keyboardSubView!.frame.origin.y + keyboardSubView!.frame.size.height - 5
                    UIView.animate(withDuration: 0.35, animations: {
                        self.mainViewController.keyboardAlarmSubView?.frame.origin.y = y
                    })
                }
                else {
                    print("keyboardSubView?.alarmAddButtonToggle == true")
                    subviewitem.titleField.resignFirstResponder()
                    subviewitem.titleField.endEditing(true)
                    mainViewController.alarmdate = (keyboardAlarmSubView?.getAlarmDate())! as Date
                    let y = keyboardSubView!.frame.origin.y + keyboardSubView!.frame.size.height - 5
                    UIView.animate(withDuration: 0.35, animations: {
                        self.mainViewController.keyboardAlarmSubView?.frame.origin.y = y
                    })
                    
                    keyboardAlarmSubView?.delegate = self
                }
            }
        }
        else {
            if alarms.count <= 3 {
                //delete alarm
                let alarmIndexSelected = keyboardSubView?.getcurrentSelectedAlarmIndexArray()
//                                    print("alarmIndexSlected   :  ",alarmIndexSelected)
                
                if ((keyboardSubView?.alarmAddButtonToggle)! == false && alarmIndexSelected! ){
                    let alert = UIAlertController(title: "박사장님 짱", message: "지울꺼야 ㅜㅜ", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let yesAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
                        keyboardSubView?.alarmCount = (keyboardSubView?.alarmCount)! - 1
                        
                        let currentSelectedAlarmIndex = keyboardSubView?.getcurrentSelectedAlarmIndex()
                        
                        switch currentSelectedAlarmIndex! {
                        case 0 :
                            keyboardSubView?.firstAlarmBack.layer.borderColor = UIColor.gray.cgColor
                        case 1 :
                            keyboardSubView?.secondAlarmBack.layer.borderColor = UIColor.gray.cgColor
                        case 2 :
                            keyboardSubView?.thirdAlarmBack.layer.borderColor = UIColor.gray.cgColor
                        default:
                            print("Out of Range")
                        }
            
                        keyboardSubView?.selectedAlarmArray[currentSelectedAlarmIndex! + 1] = false
                        
                        subviewitem.titleField.becomeFirstResponder()
                        
                        alarms.remove(at: currentSelectedAlarmIndex!)
                        print("after deleting alarm list\n \(alarms)")
                    }
                    
                    let noAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in }
                    
                    alert.addAction(yesAction)
                    alert.addAction(noAction)
                    self.mainViewController.present(alert, animated: true, completion: nil)
                }
                else{
                    subviewitem.titleField.becomeFirstResponder()
                }
            }
        }
    }
    
    func confirmAlarmClicked(alarmInfoView: AddSubInfo, alarmIndex: Int) {
        let keyboardAlarmSubView = mainViewController.keyboardAlarmSubView
        let subviewitem = mainViewController.subviewitem
        var currentSelectedAlarmIndex = mainViewController.currentSelectedAlarmIndex
        
        if alarmIndex >= 3 {
            subviewitem.titleField.becomeFirstResponder()
        }
        
        let day = keyboardAlarmSubView!.day * 12 * 60 * 60
        let hour = keyboardAlarmSubView!.hour * 60 * 60
        let minute = keyboardAlarmSubView!.minute * 60
        let interval = day + hour + minute
        
        currentSelectedAlarmIndex?[alarmIndex] = 1
//        print("currentSelectedAlarmIndex?[alarmIndex]  : " , currentSelectedAlarmIndex?[alarmIndex])
//        print("alarm Index = \(alarmIndex)")
        
        let newAlarm = mainViewController.currentWorkingStartingDate.addingTimeInterval(TimeInterval(interval))
        mainViewController.currentWorkingAlarms.append(newAlarm)

        print("alarms list\n \(mainViewController.currentWorkingAlarms)")
    }
    
    func alarmSelectionClicked(_ alarmIndex: Int, appear: Bool) {
        let keyboardSubView = mainViewController.keyboardSubView
        let keyboardAlarmSubView = mainViewController.keyboardAlarmSubView
        let subviewitem = mainViewController.subviewitem
        
        if appear {
            subviewitem.titleField.endEditing(true)
            self.mainViewController.alarmdate = (keyboardAlarmSubView?.getAlarmDate())! as Date
            let y = keyboardSubView!.frame.origin.y + keyboardSubView!.frame.size.height - 5
            UIView.animate(withDuration: 0.35, animations: {
                self.mainViewController.keyboardAlarmSubView?.frame.origin.y = y
            })
        }
        else {
            subviewitem.titleField.becomeFirstResponder()
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
    func alarmChanged() {
    }
    
    /*
     AddTodoItemDelegate Methods
     - toDoItemAddClicked()
    */
    func toDoItemAddClicked() {
        mainViewController.dismissRefreshControl()
        let subviewitem = mainViewController.subviewitem
        let color = mainViewController.currentWorkingColor
        let colorIndex = mainViewController.currentWorkingColorIndex
        let startingDate = mainViewController.currentWorkingStartingDate
        let alarms = mainViewController.currentWorkingAlarms
        
        let textFieldText = subviewitem.getTitleText()

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
        
        mainViewController.subviewitem.titleField.text = ""
    }

}
