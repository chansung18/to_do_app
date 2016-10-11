//
//  ViewController.swift
//  to_do
//
//  Created by Chansung, Park on 12/09/2016.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit
import CoreData

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
    
    var dolist = [Dolist]()
    var alarmdate : NSDate?
    
    var refreshController = UIRefreshControl()
    let subviewitem : RefreshView = RefreshView()
    
    var isInTheMiddleOfEnteringItem: Bool = false
    var isRefreshControlFullyVisible: Bool = false
    
    var keyboardSubView: AddSubInfo?
    var keyboardAlarmSubView: AlarmSubInfo?
    
    override func viewDidAppear(animated: Bool) {
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
        refreshController.tintColor = UIColor.clearColor()
        subviewitem.delegate = self
        subviewitem.frame = refreshController.bounds
        subviewitem.frame.size.width = subviewitem.frame.size.width - 25
        refreshController.addSubview(subviewitem)
        
        print("view.frame = \(view.frame)")
        print("tbl.frame = \(tableView.frame)")
        print("refreshView.frame = \(subviewitem.frame)")
        print("refreshControl.bounds = \(refreshController.bounds)")
        
        let margins = refreshController.layoutMarginsGuide
        subviewitem.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        subviewitem.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        subviewitem.topAnchor.constraintEqualToAnchor(margins.topAnchor, constant: 1.0)
        
        refreshController.addTarget(self, action: #selector(didRefresh), forControlEvents: .ValueChanged)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        tableView.addSubview(refreshController)
    }
    
    func keyboardWillShow(nofification : NSNotification){
        let userInfo:NSDictionary = nofification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
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
            UIView.animateWithDuration(0.2) {
                self.keyboardSubView?.alpha = 1
            }
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
            UIView.animateWithDuration(0.2) {
                self.keyboardAlarmSubView?.frame.origin.y = y + height
            }
            
            keyboardAlarmSubView?.day = 77 
        }
    }
    
    func keyboardSubViewTapped(gesture: UITapGestureRecognizer) { /* do nothing */ }
    
    func didRefresh() {
        showRefreshControl()
        subviewitem.titleField.becomeFirstResponder()
        
        let entityDescription = NSEntityDescription.entityForName("Dolist",
                                                                  inManagedObjectContext: CoreDataController.sharedInstace.managedObjectContext)
        currentDoItem = Dolist(entity: entityDescription!,
                               insertIntoManagedObjectContext: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
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
    func tableViewTapped(gesture: UITapGestureRecognizer) {
        if isInTheMiddleOfEnteringItem {
            if gesture.locationInView(self.dummyView).y < self.keyboardSubView?.frame.origin.y {
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
        UIView.animateWithDuration(0.5) {
            self.view.exchangeSubviewAtIndex(0, withSubviewAtIndex: 1)
        }
        
        UIView.animateWithDuration(0.5, animations: { 
            self.refreshController.alpha = 0.0
            self.keyboardSubView?.alpha = 0
            self.keyboardAlarmSubView?.frame.origin.y = self.keyboardAlarmSubView!.frame.origin.y + self.keyboardAlarmSubView!.frame.height
        }) { (completed) in
            if completed {
                self.keyboardSubView?.removeFromSuperview()
                self.keyboardAlarmSubView?.removeFromSuperview()
                
                self.keyboardSubView = nil
                self.keyboardAlarmSubView = nil
            }
        }
    
        subviewitem.titleField.endEditing(true)
        refreshController.endRefreshing()
        isInTheMiddleOfEnteringItem = false
        isRefreshControlFullyVisible = false
    }
    
    func showRefreshControl() {
        UIView.animateWithDuration(0.5) {
            self.view.exchangeSubviewAtIndex(0, withSubviewAtIndex: 1)
        }
        
        isInTheMiddleOfEnteringItem = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dolist.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoListCell") as? ToDoListTableViewCell
        
        if let width = cell?.colorButton.bounds.width {
            print("width = \(width)")
            cell?.colorButton.layer.cornerRadius = width / 2.0
            cell?.colorButton.layer.masksToBounds = true
        }
        
        cell?.backgroundColor = UIColor.clearColor()
        let doItem = dolist[indexPath.row]
        cell?.originalTitle = doItem.title
        cell?.index = indexPath.row
        cell?.delegate = self
        
        if doItem.lineflag == NSNumber(bool: true) {
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
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        (tableView.cellForRowAtIndexPath(indexPath) as! ToDoListTableViewCell).isEditingMode = true
        
        UIButton.appearance().setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        let editAction = UITableViewRowAction(style: .Normal, title: "🖊", handler:{ action, indexpath in
            //edit Action codes
        });
        
        editAction.backgroundColor = UIColor.whiteColor()
        
        let deleteAction = UITableViewRowAction(style: .Normal, title: "╳", handler:{ action, indexpath in
            //delete action codes
            tableView.beginUpdates()
            CoreDataController.sharedInstace.removeFromCoreData(self.dolist[indexPath.row])
            self.dolist.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
        });
        deleteAction.backgroundColor = UIColor.whiteColor()
        
        return [deleteAction, editAction]
    }
    
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        //(tableView.cellForRowAtIndexPath(indexPath) as! ToDoListTableViewCell).isEditingMode = false
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("cell selection")
    }
    
    func cellLongPressed(gesture: UILongPressGestureRecognizer) {
        print("long pressed...")
    }
    
    // ToDoListTableViewCellDelegate
    func cellValueChanged(cell: ToDoListTableViewCell) {
        let index = cell.index

        print("cellValueChanged is called on Cell Index \(index)")
        
        dolist[index].title = cell.originalTitle
        dolist[index].lineflag = cell.isCrossedOut
    }
    
    //AddSubInfoDelegate
    func addAlarmClicked(addAction: Bool) {
        if addAction {
            if currentDoItem?.alarms?.count <= 3 {
                if keyboardSubView?.alarmAddButtonToggle == false {
                    subviewitem.titleField.endEditing(true)
                    self.alarmdate = (keyboardAlarmSubView?.getAlarmDate())!
                    let y = keyboardSubView!.frame.origin.y + keyboardSubView!.frame.size.height - 5
                    UIView.animateWithDuration(0.35) {
                        self.keyboardAlarmSubView?.frame.origin.y = y
                    }
                }
                else {
                    subviewitem.titleField.becomeFirstResponder()
                }
            }
        }
        else {
            
        }
    }

    func confirmAlarmClicked(alarmIndex: Int) {
        if alarmIndex >= 3 {
            subviewitem.titleField.becomeFirstResponder()
        }
        
        let day = keyboardAlarmSubView!.day * 12 * 60 * 60
        let hour = keyboardAlarmSubView!.hour * 60 * 60
        let minute = keyboardAlarmSubView!.minute * 60
        let interval = day + hour + minute
        
        print("alarm Index = \(alarmIndex)")
//        let newAlarm = currentDoItem?.startingDate?.dateByAddingTimeInterval(Double(interval))
//        
//        let copy = NSMutableSet.init(set: currentDoItem!.alarms!)
//        copy.addObject(<#T##object: AnyObject##AnyObject#>)
//        currentDoItem!.alarms = copy
//        currentDoItem?.alarms.se
    }
    
    func alarmSelectionClicked(alarmIndex: Int, appear: Bool) {
        if appear {
            subviewitem.titleField.endEditing(true)
            self.alarmdate = (keyboardAlarmSubView?.getAlarmDate())!
            let y = keyboardSubView!.frame.origin.y + keyboardSubView!.frame.size.height - 5
            UIView.animateWithDuration(0.35) {
                self.keyboardAlarmSubView?.frame.origin.y = y
            }
        }
        else {
            subviewitem.titleField.becomeFirstResponder()
        }
    }

    func colorSelectionClicked(color: UIColor) {
        let coreImageColor = CoreImage.CIColor(color: color)
        currentDoItem?.color?.r = coreImageColor.red
        currentDoItem?.color?.g = coreImageColor.green
        currentDoItem?.color?.b = coreImageColor.blue
    }
    
    //AddTodoItemDelegate
    func toDoItemAddClicked() {
        dismissRefreshControl()
        
        let textFieldText = subviewitem.getTitleText()
        
        print("toDoItemAddClicked")
        if self.alarmdate == nil {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy'-'MM'-'dd HH:mm:ss"
            let someDate = formatter.dateFromString("2014-12-25 10:25:00")
            print("somdate  : " + String(someDate))
            self.alarmdate = someDate
        }
        
        let colorR = arc4random() % 256
        let colorG = arc4random() % 256
        let colorB = arc4random() % 256
        
        let entityDescription = NSEntityDescription.entityForName("Color",
                                                                  inManagedObjectContext: CoreDataController.sharedInstace.managedObjectContext)
        let color = Color(entity: entityDescription!,
                          insertIntoManagedObjectContext: CoreDataController.sharedInstace.managedObjectContext)
        color.r = NSNumber(unsignedInt: colorR)
        color.g = NSNumber(unsignedInt: colorG)
        color.b = NSNumber(unsignedInt: colorB)
        color.a = NSNumber(unsignedInt: colorB)
        
        if (textFieldText != "null") {
            if textFieldText.stringByReplacingOccurrencesOfString(" ", withString: "") != "" {
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

