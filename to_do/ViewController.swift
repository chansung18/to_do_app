//
//  ViewController.swift
//  to_do
//
//  Created by Chansung, Park on 12/09/2016.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit
import CoreData
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class ViewController: UIViewController,
                      UITableViewDataSource,
                      UITableViewDelegate,
                      ToDoListTableViewCellDelegate,
                      AddSubInfoDelegate,
                      AddTodoItemDelegate,
                      AlarmSubinfoDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dummyView: UIView!
    
    var currentDoItem: Dolist?
    var currentSelectedAlarmIndex: [Int]?
    var dolist = [Dolist]()
    var alarmdate : Date?
    
    var refreshController = UIRefreshControl()
    let subviewitem : RefreshView = RefreshView()
    
    var isInTheMiddleOfEnteringItem: Bool = false
    var isRefreshControlFullyVisible: Bool = false
    
    var keyboardSubView: AddSubInfo?
    var keyboardAlarmSubView: AlarmSubInfo?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 65, 0)
        
        dolist = CoreDataController.sharedInstace.loadFromCoredata()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make UITapGestureRecognizer when tapping dummyview which is for fake
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        dummyView.addGestureRecognizer(tapGesture)
        
        refreshController.alpha = 0.0
        
        refreshController.frame.size.width = view.frame.size.width
        refreshController.tintColor = UIColor.clear
        subviewitem.delegate = self
        subviewitem.frame = refreshController.bounds
        subviewitem.frame.size.width = subviewitem.frame.size.width - 25
        refreshController.addSubview(subviewitem)
        
        print("view.frame = \(view.frame)")
        print("tbl.frame = \(tableView.frame)")
        print("refreshView.frame = \(subviewitem.frame)")
        print("refreshControl.bounds = \(refreshController.bounds)")
        
        let margins = refreshController.layoutMarginsGuide
        subviewitem.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        subviewitem.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        subviewitem.topAnchor.constraint(equalTo: margins.topAnchor, constant: 1.0)
        
        refreshController.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        tableView.addSubview(refreshController)
    }
    
    func keyboardWillShow(_ nofification : Notification){
        let userInfo:NSDictionary = (nofification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        if keyboardSubView == nil {
            keyboardSubView = AddSubInfo(frame: CGRect(x: 0,
                                                   y: dummyView.frame.height - keyboardHeight - 150,
                                                   width: dummyView.frame.width,
                                                   height: 150))
            keyboardSubView?.delegate = self
            keyboardSubView?.selectedColorIndex = 4
            if let alarms = currentDoItem?.alarms {
                keyboardSubView?.alarmCount = alarms.count
            }
            dummyView.addSubview(keyboardSubView!)
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.keyboardSubView?.alpha = 1
            }) 
        }
            
        let x = CGFloat(0)
        let y = keyboardSubView!.frame.origin.y + keyboardSubView!.frame.size.height - 10
        let width = dummyView.frame.size.width
        let height = keyboardHeight + 50
        self.keyboardSubView?.delegate = self
        if keyboardAlarmSubView == nil {
            keyboardAlarmSubView = AlarmSubInfo(frame: CGRect(x: x, y: y + height, width: width, height: height))
            keyboardAlarmSubView?.alpha = 1
            dummyView.addSubview(keyboardAlarmSubView!)
            
            let dummyTapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardSubViewTapped))
            keyboardAlarmSubView?.addGestureRecognizer(dummyTapGesture)
            keyboardSubView?.addGestureRecognizer(dummyTapGesture)
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.keyboardAlarmSubView?.frame.origin.y = y + height
            }) 
            
            keyboardAlarmSubView?.day = 77 
        }
    }
    
    func keyboardSubViewTapped(_ gesture: UITapGestureRecognizer) { /* do nothing */ }
    
    func didRefresh() {
        showRefreshControl()
        subviewitem.titleField.becomeFirstResponder()
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Dolist",
                                                                  in: CoreDataController.sharedInstace.managedObjectContext)
        currentDoItem = Dolist(entity: entityDescription!,
                               insertInto: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pullDistance = max(0.0, -refreshController.frame.origin.y);

        if pullDistance > 0 && isRefreshControlFullyVisible == false {
            refreshController.alpha = pullDistance * 0.01
        }
        
        if refreshController.alpha >= 1 {
            refreshController.alpha = 1
            isRefreshControlFullyVisible = true
        }
    }
    
    /*
     name : tableViewTapped
     parameter : UITapGestureRecognizer(tap)
     function : to cancle refreshview
    */
    func tableViewTapped(_ gesture: UITapGestureRecognizer) {
        if isInTheMiddleOfEnteringItem {
            if gesture.location(in: self.dummyView).y < self.keyboardSubView?.frame.origin.y {
                dismissRefreshControl()
                currentDoItem = nil
            }
        }
    }
    
    /*
     name : dismissRefreshControl
     function : adjust visivble state of dummyview
     */
    func dismissRefreshControl() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.exchangeSubview(at: 0, withSubviewAt: 1)
        }) 
        
        UIView.animate(withDuration: 0.5, animations: { 
            self.refreshController.alpha = 0.0
            self.keyboardSubView?.alpha = 0
            self.keyboardAlarmSubView?.frame.origin.y = self.keyboardAlarmSubView!.frame.origin.y + self.keyboardAlarmSubView!.frame.height
        }, completion: { (completed) in
            if completed {
                self.keyboardSubView?.removeFromSuperview()
                self.keyboardAlarmSubView?.removeFromSuperview()
                
                self.keyboardSubView = nil
                self.keyboardAlarmSubView = nil
            }
        }) 
    
        subviewitem.titleField.endEditing(true)
        refreshController.endRefreshing()
        isInTheMiddleOfEnteringItem = false
        isRefreshControlFullyVisible = false
    }
    
    func showRefreshControl() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.exchangeSubview(at: 0, withSubviewAt: 1)
        }) 
        
        isInTheMiddleOfEnteringItem = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dolist.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell") as? ToDoListTableViewCell
        
        if let width = cell?.colorButton.bounds.width {
            print("width = \(width)")
            cell?.colorButton.layer.cornerRadius = width / 2.0
            cell?.colorButton.layer.masksToBounds = true
        }
        
        cell?.backgroundColor = UIColor.clear
        let doItem = dolist[(indexPath as NSIndexPath).row]
        cell?.originalTitle = doItem.title
        cell?.index = (indexPath as NSIndexPath).row
        cell?.delegate = self
        
        if doItem.lineflag == NSNumber(value: true as Bool) {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (cell?.originalTitle)!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell?.titleLabel.attributedText = attributeString
            
        }
        
        if let color = doItem.color {
            let colorR = CGFloat(color.r!) / 255
            let colorG = CGFloat(color.g!) / 255
            let colorB = CGFloat(color.b!) / 255
        
            let labelColor = UIColor(red:colorR, green: colorG, blue: colorB, alpha: 1)
            cell?.colorButton.backgroundColor = labelColor
        }
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.cellLongPressed))
        lpgr.minimumPressDuration = 1.0
        cell?.addGestureRecognizer(lpgr)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        (tableView.cellForRow(at: indexPath) as! ToDoListTableViewCell).isEditingMode = true
        
        UIButton.appearance().setTitleColor(UIColor.black, for: UIControlState())
        
        let editAction = UITableViewRowAction(style: .normal, title: "🖊", handler:{ action, indexpath in
            //edit Action codes
        });
        
        editAction.backgroundColor = UIColor.white
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "╳", handler:{ action, indexpath in
            //delete action codes
            tableView.beginUpdates()
            CoreDataController.sharedInstace.removeFromCoreData(self.dolist[(indexPath as NSIndexPath).row])
            self.dolist.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        });
        deleteAction.backgroundColor = UIColor.white
        
        return [deleteAction, editAction]
    }
    
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        //(tableView.cellForRowAtIndexPath(indexPath) as! ToDoListTableViewCell).isEditingMode = false
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("cell selection")
    }
    
    func cellLongPressed(_ gesture: UILongPressGestureRecognizer) {
        print("long pressed...")
    }
    
    // ToDoListTableViewCellDelegate
    func cellValueChanged(_ cell: ToDoListTableViewCell) {
        let index = cell.index

        print("cellValueChanged is called on Cell Index \(index)")
        
        dolist[index].title = cell.originalTitle
        dolist[index].lineflag = cell.isCrossedOut as NSNumber?
    }
    
    //AddSubInfoDelegate
    func addAlarmClicked(_ addAction: Bool) {
        if addAction {
            if currentDoItem?.alarms?.count <= 3 {
                if keyboardSubView?.alarmAddButtonToggle == false {
                    //false?? for when ??
                    print("keyboardSubView?.alarmAddButtonToggle == false")
                    subviewitem.titleField.endEditing(true)
                    self.alarmdate = (keyboardAlarmSubView?.getAlarmDate())! as Date
                    let y = keyboardSubView!.frame.origin.y + keyboardSubView!.frame.size.height - 5
                    UIView.animate(withDuration: 0.35, animations: {
                        self.keyboardAlarmSubView?.frame.origin.y = y
                    })
                
                }
                else if keyboardSubView?.alarmAddButtonToggle == true {
                    //close keyboard and open add alarmSubInfoView
                     print("keyboardSubView?.alarmAddButtonToggle == true")
                     subviewitem.titleField.resignFirstResponder()
                     subviewitem.titleField.endEditing(true)
                     self.alarmdate = (keyboardAlarmSubView?.getAlarmDate())! as Date
                     let y = keyboardSubView!.frame.origin.y + keyboardSubView!.frame.size.height - 5
                     UIView.animate(withDuration: 0.35, animations: {
                     self.keyboardAlarmSubView?.frame.origin.y = y
                     })//end (close keyboard and open add alarmSubInfoView)
                }
                else {
                    subviewitem.titleField.becomeFirstResponder()
                }
            }


        }
        else {
            if currentDoItem?.alarms?.count <= 3 {
                //delete alarm
                let alarmIndexSlected = keyboardSubView?.getcurrentSelectedAlarmIndexArray()
                print("alarmIndexSlected   :  ",alarmIndexSlected)
                if ((keyboardSubView?.alarmAddButtonToggle)! == false && alarmIndexSlected! ){
                    let alert = UIAlertView()
                    alert.title = "삭제 하고 싶어요 ? "
                    alert.message = "삭제 하시겠습니까 ?"
                    alert.addButton(withTitle: "확인")
                    alert.show()
                    
                    print("keyboardSubView?.alarmAddButtonToggle == false")
                    subviewitem.titleField.endEditing(true)
                    self.alarmdate = (keyboardAlarmSubView?.getAlarmDate())! as Date
                    let y = keyboardSubView!.frame.origin.y + keyboardSubView!.frame.size.height - 5
                    UIView.animate(withDuration: 0.35, animations: {
                        self.keyboardAlarmSubView?.frame.origin.y = y
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
                    

                }
                else{
                    subviewitem.titleField.becomeFirstResponder()
                    
                }
            }

            
            
            
        }
    }

    func confirmAlarmClicked(_ alarmIndex: Int) {
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
        if appear {
            subviewitem.titleField.endEditing(true)
            self.alarmdate = (keyboardAlarmSubView?.getAlarmDate())! as Date
            let y = keyboardSubView!.frame.origin.y + keyboardSubView!.frame.size.height - 5
            UIView.animate(withDuration: 0.35, animations: {
                self.keyboardAlarmSubView?.frame.origin.y = y
            }) 
        }
        else {
            subviewitem.titleField.becomeFirstResponder()
        }
    }

    func colorSelectionClicked(_ color: UIColor) {
        let coreImageColor = CoreImage.CIColor(color: color)
        currentDoItem?.color?.r = coreImageColor.red as NSNumber?
        currentDoItem?.color?.g = coreImageColor.green as NSNumber?
        currentDoItem?.color?.b = coreImageColor.blue as NSNumber?
    }
    
    //AddTodoItemDelegate
    func toDoItemAddClicked() {
        dismissRefreshControl()
        
        let textFieldText = subviewitem.getTitleText()
        
        print("toDoItemAddClicked")
        if self.alarmdate == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy'-'MM'-'dd HH:mm:ss"
            let someDate = formatter.date(from: "2014-12-25 10:25:00")
            print("somdate  : " + String(describing: someDate))
            self.alarmdate = someDate
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
                let newItem = CoreDataController.sharedInstace.saveToCoredata(textFieldText, deadline: self.alarmdate!, color: color)
                self.dolist.append(newItem)
                self.tableView.reloadData()
                
            }
            else {
                print("textFieldText = empty")
            }
        }
        else {
            print("textFieldText = nil")
        }
    }
    func alarmChanged() {
        print("timechaged")
        
    }
}

