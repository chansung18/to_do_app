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
    
    //AddSubInfoDelegate
    func addAlarmClicked(_ addAction: Bool) {
        let currentDoItem = mainViewController.currentDoItem
        let keyboardSubView = mainViewController.keyboardSubView
        let keyboardAlarmSubView = mainViewController.keyboardAlarmSubView
        let subviewitem = mainViewController.subviewitem
        
        if addAction {
            if let currentDoItemAlarms = currentDoItem?.alarms {
                if currentDoItemAlarms.count <= 3 {
                    if keyboardSubView?.alarmAddButtonToggle == false {
                        //false?? for when ??
                        print("keyboardSubView?.alarmAddButtonToggle == false")
                        subviewitem.titleField.endEditing(true)
                        mainViewController.alarmdate = (keyboardAlarmSubView?.getAlarmDate())! as Date
                        let y = keyboardSubView!.frame.origin.y + keyboardSubView!.frame.size.height - 5
                        UIView.animate(withDuration: 0.35, animations: {
                            self.mainViewController.keyboardAlarmSubView?.frame.origin.y = y
                        })
                        
                    }
                    else if keyboardSubView?.alarmAddButtonToggle == true {
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
                    else {
                        subviewitem.titleField.becomeFirstResponder()
                    }
                }
            }
        }
        else {
            if let currentDoItemAlarms = currentDoItem?.alarms {
                if currentDoItemAlarms.count <= 3 {
                    //delete alarm
                    let alarmIndexSlected = keyboardSubView?.getcurrentSelectedAlarmIndexArray()
                    print("alarmIndexSlected   :  ",alarmIndexSlected)
                    if ((keyboardSubView?.alarmAddButtonToggle)! == false && alarmIndexSlected! ){
                        let alert = UIAlertController(title: "박사장님 짱", message: "지울꺼야 ㅜㅜ", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let yesAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
                            
                            print("keyboardSubView?.alarmAddButtonToggle == false")
                            subviewitem.titleField.endEditing(true)
                            
                            self.mainViewController.alarmdate = (keyboardAlarmSubView?.getAlarmDate())! as Date
                            let y = keyboardSubView!.frame.origin.y + keyboardSubView!.frame.size.height - 5
                            UIView.animate(withDuration: 0.35, animations: {
                                self.mainViewController.keyboardAlarmSubView?.frame.origin.y = y
                            })
                            
                            subviewitem.titleField.becomeFirstResponder()
                            keyboardSubView?.alarmCount = (keyboardSubView?.alarmCount)! - 1
                            
                            let currentSelectedAlarmIndex = keyboardSubView?.getcurrentSelectedAlarmIndex()
                            if currentSelectedAlarmIndex == 0 {
                                keyboardSubView?.firstAlarmBack.layer.borderColor = UIColor.gray.cgColor
                            }
                            else if currentSelectedAlarmIndex == 1 {
                                keyboardSubView?.secondAlarmBack.layer.borderColor = UIColor.gray.cgColor
                            }
                            else if currentSelectedAlarmIndex == 2 {
                                keyboardSubView?.thirdAlarmBack.layer.borderColor = UIColor.gray.cgColor
                            }
                            keyboardSubView?.selectedAlarmArray[currentSelectedAlarmIndex! + 1] = false
                            
                            subviewitem.titleField.becomeFirstResponder()
                        }
                        let noAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
                            //                         self.subviewitem.titleField.becomeFirstResponder()
                            
                        }
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
    }
    
    func confirmAlarmClicked(_ alarmIndex: Int) {
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
        print("currentSelectedAlarmIndex?[alarmIndex]  : " , currentSelectedAlarmIndex?[alarmIndex])
        print("alarm Index = \(alarmIndex)")
        //        let newAlarm = currentDoItem?.startingDate?.dateByAddingTimeInterval(Double(interval))
        //
        //        let copy = NSMutableSet.init(set: currentDoItem!.alarms!)
        //        copy.addObject(<#T##object: AnyObject##AnyObject#>)
        //        currentDoItem!.alarms = copy
        //        currentDoItem?.alarms.se
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
    
    func colorSelectionClicked(_ color: UIColor) {
        let currentDoItem = mainViewController.currentDoItem
        
        let coreImageColor = CoreImage.CIColor(color: color)
        currentDoItem?.color?.r = coreImageColor.red as NSNumber?
        currentDoItem?.color?.g = coreImageColor.green as NSNumber?
        currentDoItem?.color?.b = coreImageColor.blue as NSNumber?
    }

    func alarmChanged() {
        print("timechaged")
        //self.keyboardSubView?.alarmComfirmButton.isEnabled = true
        //self.keyboardSubView?.alarmComfirmButton.alpha = 1.0
    }
    
    //AddTodoItemDelegate
    func toDoItemAddClicked() {
        
        mainViewController.dismissRefreshControl()
        let subviewitem = mainViewController.subviewitem
        
        let textFieldText = subviewitem.getTitleText()
        
        print("toDoItemAddClicked")
        if mainViewController.alarmdate == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy'-'MM'-'dd HH:mm:ss"
            let someDate = formatter.date(from: "2014-12-25 10:25:00")
            print("somdate  : " + String(describing: someDate))
            mainViewController.alarmdate = someDate
        }
        
        let colorR = arc4random() % 256
        let colorG = arc4random() % 256
        let colorB = arc4random() % 256
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Color",
                                                           in: CoreDataController.sharedInstace.managedObjectContext)
        let color = Color(entity: entityDescription!,
                          insertInto: CoreDataController.sharedInstace.managedObjectContext)
        color.r = NSNumber(value: colorR as UInt32)
        color.g = NSNumber(value: colorG as UInt32)
        color.b = NSNumber(value: colorB as UInt32)
        color.a = NSNumber(value: colorB as UInt32)
        
        if (textFieldText != "null") {
            if textFieldText.replacingOccurrences(of: " ", with: "") != "" {
                let newItem = CoreDataController.sharedInstace.saveToCoredata(textFieldText, deadline: mainViewController.alarmdate!, color: color)
                mainViewController.dolist.append(newItem)
                mainViewController.tableView.reloadData()
                
            }
            else {
                print("textFieldText = empty")
            }
        }
        else {
            print("textFieldText = nil")
        }
    }

}
