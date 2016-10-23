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
                      UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dummyView: UIView!
    
    /* 
     Delegate Methods in Custom UI,
     all is implemented in CustomDelegateActionHandlers 
    */
    var customDelegateHandler: CustomDelegateActionHandlers!
    
    /* 
     current* something variable is currently working data
     while editing Dolist or creating new Dolist item
    */
    var currentWorkingTitle: String = String()
    var currentWorkingColorIndex: Int = 0
    var currentWorkingColor: UIColor = UIColor.gray
    var currentWorkingAlarms: [Date] = [Date]()
    var currentWorkingStartingDate: Date = Date() {
        didSet {
            print("\n\n currentWorkingStartingDate set \n\n")
        }
    }
    var isCurrentWorkingNewItem: Bool = true
    
    var currentSelectedAlarmIndex: [Int]?
    var dolist = [Dolist]()
    var alarmdate : Date?
    
    var isInTheMiddleOfEnteringItem: Bool = false
    var isRefreshControlFullyVisible: Bool = false
    var isInTheMiddleOfLongPressing: Bool = false
    
    /* RefreshControl and Custom RefreshView in it */
    var refreshControl = UIRefreshControl()
    let refreshView : RefreshView = RefreshView()
   
    /* Color/Alarm Selection View */
    var colorAlarmSelectionView: AddSubInfo?
    
    /* Alarm date choosing View */
    var alarmDateChoosingView: AlarmSubInfo?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 65, 0)
        
        dolist = CoreDataController.sharedInstace.loadFromCoredata()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customDelegateHandler = CustomDelegateActionHandlers(viewController: self)
        
        // make UITapGestureRecognizer when tapping dummyview which is for fake
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        dummyView.addGestureRecognizer(tapGesture)
        
        refreshControl.alpha = 0.0
        refreshControl.frame.size.width = view.frame.size.width
        refreshControl.tintColor = UIColor.clear
        
        refreshView.delegate = customDelegateHandler
        refreshView.frame = refreshControl.bounds
        refreshView.frame.size.width = refreshView.frame.size.width - 25
        refreshControl.addSubview(refreshView)
        
        refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
    }
    
    func keyboardWillShow(_ nofification : Notification){
        /* Keyboard Infromation Retrieving */
        let userInfo: NSDictionary = (nofification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardArea = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardArea.height
        
        if colorAlarmSelectionView == nil {
            colorAlarmSelectionView = AddSubInfo(frame: CGRect(x: 0,
                                                   y: dummyView.frame.height - keyboardHeight - 150,
                                                   width: dummyView.frame.width,
                                                   height: 150))
            dummyView.addSubview(colorAlarmSelectionView!)
            colorAlarmSelectionView?.delegate = customDelegateHandler
            colorAlarmSelectionView?.selectedColorIndex = currentWorkingColorIndex
            colorAlarmSelectionView?.alarmCount = currentWorkingAlarms.count
            refreshView.titleField.text = currentWorkingTitle
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.colorAlarmSelectionView?.alpha = 1
            })
            colorAlarmSelectionView?.selectedColorIndex = currentWorkingColorIndex
            colorAlarmSelectionView?.alarmCount = currentWorkingAlarms.count
            refreshView.titleField.text = currentWorkingTitle

        }
        
        let x = CGFloat(0)
        let y = colorAlarmSelectionView!.frame.origin.y + colorAlarmSelectionView!.frame.size.height - 10
        let width = dummyView.frame.size.width
        let height = keyboardHeight + 50
        self.colorAlarmSelectionView?.delegate = customDelegateHandler
        
        if alarmDateChoosingView == nil {
            alarmDateChoosingView = AlarmSubInfo(frame: CGRect(x: x, y: y + height, width: width, height: height))
            alarmDateChoosingView?.alpha = 1
            dummyView.addSubview(alarmDateChoosingView!)
            
            let dummyTapGesture = UITapGestureRecognizer(target: self, action: #selector(colorAlarmSelectionViewTapped))
            alarmDateChoosingView?.addGestureRecognizer(dummyTapGesture)
            colorAlarmSelectionView?.addGestureRecognizer(dummyTapGesture)
            
            if currentWorkingAlarms.count >= 3 {
                colorAlarmSelectionView?.alarmAddButtonToggle = false
            }
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.alarmDateChoosingView?.frame.origin.y = y + height
            })
        }
    }
    
    func colorAlarmSelectionViewTapped(_ gesture: UITapGestureRecognizer) { /* do nothing */ }
    
    func didRefresh() {
        showRefreshControl()
        refreshView.titleField.becomeFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isRefreshControlFullyVisible {
            refreshControl.alpha = 1.0
        }
        else {
            refreshControl.alpha = -scrollView.contentOffset.y * 0.001
        }
    }
    
    /*
     name : tableViewTapped
     parameter : UITapGestureRecognizer(tap)
     function : to cancle refreshview
    */
    func tableViewTapped(_ gesture: UITapGestureRecognizer) {
        if isInTheMiddleOfEnteringItem {
            if gesture.location(in: self.dummyView).y < (self.colorAlarmSelectionView?.frame.origin.y)! {
                dismissRefreshControl()
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
            self.colorAlarmSelectionView?.alpha = 0
            self.alarmDateChoosingView?.frame.origin.y = self.alarmDateChoosingView!.frame.origin.y + self.alarmDateChoosingView!.frame.height
        },
        completion: { (completed) in
            if completed {
                self.colorAlarmSelectionView?.removeFromSuperview()
                self.alarmDateChoosingView?.removeFromSuperview()
                
                self.colorAlarmSelectionView = nil
                self.alarmDateChoosingView = nil
                
                let newOffset = CGPoint(x: 0, y: 0)
                self.tableView.setContentOffset(newOffset, animated: true)
                
                self.refreshView.titleField.endEditing(true)
                self.isInTheMiddleOfEnteringItem = false
                self.isRefreshControlFullyVisible = false
                self.isInTheMiddleOfLongPressing = false
                self.isCurrentWorkingNewItem = true
                
                self.currentWorkingAlarms = [Date]()
                self.currentWorkingColorIndex = 0
                self.currentWorkingColor = UIColor.gray
                self.currentWorkingTitle = ""
                
                self.refreshView.titleField.text = ""
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    func showRefreshControl() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.exchangeSubview(at: 0, withSubviewAt: 1)
        })
        
        isInTheMiddleOfEnteringItem = true
        currentWorkingStartingDate = Date()
        refreshControl.alpha = 1.0
        isRefreshControlFullyVisible = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dolist.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell") as! ToDoListTableViewCell
        
        let doItem = dolist[indexPath.row]
        
        cell.backgroundColor = UIColor.clear
        cell.item = doItem
        cell.originalTitle = doItem.title
        
        if doItem.lineflag == NSNumber(value: true as Bool) {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (cell.originalTitle)!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.titleLabel.attributedText = attributeString
            cell.isCrossedOut = true
        }
        
        let colorR = CGFloat(doItem.color!.r!) / 255
        let colorG = CGFloat(doItem.color!.g!) / 255
        let colorB = CGFloat(doItem.color!.b!) / 255
        
        let labelColor = UIColor(red:colorR, green: colorG, blue: colorB, alpha: 1)
        cell.colorButton.backgroundColor = labelColor
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.cellLongPressed))
        lpgr.minimumPressDuration = 1.0
        cell.addGestureRecognizer(lpgr)
        
        if cell.contentView.subviews[0].subviews.count < 3 {
            if doItem.alarms != nil && doItem.alarms!.count > 0 {
                var minAlarm = Date(timeIntervalSinceReferenceDate: 9999999999)
                
                for alarm in (doItem.alarms?.allObjects)! {
                    let nsAlarm = alarm as! Alarm
                    if minAlarm.timeIntervalSince(nsAlarm.alarm!) > 0 {
                        minAlarm = nsAlarm.alarm!
                    }
                }
                
                let minInterval = minAlarm.timeIntervalSinceNow
                let startingDateInterval = minAlarm.timeIntervalSince(doItem.startingDate!)

                var cellFrameWidth : Int?
                
                //onday 86386
                if(minInterval > 0 ){
                    cellFrameWidth = Int(cell.frame.width) - Int(Double(minInterval/startingDateInterval)*Double(cell.frame.width))
                }
                else{
                    cellFrameWidth = Int(cell.frame.width)
                }
                
                let gaugeView = UIView(frame: CGRect(x: 0, y: 0, width:Int(cellFrameWidth!), height: Int(cell.frame.height)))
                gaugeView.backgroundColor = labelColor
                gaugeView.alpha = 0.2
                cell.contentView.subviews[0].addSubview(gaugeView)
                cell.contentView.subviews[0].sendSubview(toBack: gaugeView)
            }
        }
        else {
            cell.contentView.subviews[0].subviews[0].backgroundColor = labelColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        (tableView.cellForRow(at: indexPath) as! ToDoListTableViewCell).isEditingMode = true
        UIButton.appearance().setTitleColor(UIColor.black, for: UIControlState())
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "╳", handler:{ action, indexpath in
            //delete action codes
            tableView.beginUpdates()
            CoreDataController.sharedInstace.removeFromCoreData(self.dolist[(indexPath as NSIndexPath).row])
            self.dolist.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        });
        deleteAction.backgroundColor = UIColor.white
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("cell selection")
    }
    
    func cellLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if !isInTheMiddleOfLongPressing {
            print("long pressed...\(gesture.view!.tag)")
            
            let touchPoint = gesture.location(in: tableView)
            let row = tableView.indexPathForRow(at: touchPoint)
            if row != nil {
                let currentTodoItem = dolist[row!.row]
                
                for alarm in currentTodoItem.alarms! {
                    currentWorkingAlarms.append((alarm as! Alarm).alarm!)
                }
                
                let newOffset = CGPoint(x: 0, y: tableView.contentOffset.y-(refreshControl.frame.size.height*2))
                tableView.setContentOffset(newOffset, animated: true)
                didRefresh()
                
                currentWorkingStartingDate = currentTodoItem.startingDate!
                currentWorkingTitle = currentTodoItem.title!
                currentWorkingColorIndex = currentTodoItem.color?.index as! Int
                print("currentWorkingColorIndex = \(currentWorkingColorIndex)")
                refreshView.titleField.text = currentTodoItem.title
                isInTheMiddleOfLongPressing = true
            }
        }
    }
    
    func showAlarmDateChoosingView() {
        refreshView.titleField.endEditing(true)
        let y = colorAlarmSelectionView!.frame.origin.y + colorAlarmSelectionView!.frame.size.height - 5
        
        UIView.animate(withDuration: 0.35, animations: {
            self.alarmDateChoosingView!.frame.origin.y = y
        })
    }
    
    func getRecentestAlarm(item: Dolist) -> Date? {
        if let alarms = item.alarms?.allObjects as? [Alarm] {
            if alarms.count > 0 {
                let result = alarms.sorted { $0.alarm! > $1.alarm! }
                return result[0].alarm
            }
        }
        
        return nil
    }
}

