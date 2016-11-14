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
    var currentWorkingAlarms: [Date] = [Date]()
    var currentWorkingStartingDate: Date = Date()
    
    var currentSelectedAlarmIndex: [Int]?
    var dolist = [Dolist]()
    var alarmdate : Date?
    
    var isInTheMiddleOfEnteringItem: Bool = false
    var isRefreshControlFullyVisible: Bool = false
    var isInTheMiddleOfLongPressing: Bool = false
    
    /* RefreshControl and Custom RefreshView in it */
    var refreshView : RefreshView?
   
    /* Color/Alarm Selection View */
    var colorAlarmSelectionView: AddSubInfo?
    let dummyAlarmSelectionView: AddSubInfo = AddSubInfo()
    
    /* Alarm date choosing View */
    var alarmDateChoosingView: AlarmSubInfo?

    func initialDataSet() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            dolist = CoreDataController.sharedInstace.loadFromCoredata()
        }
        else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            setupInitialItems()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 65, 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialDataSet()
        customDelegateHandler = CustomDelegateActionHandlers(viewController: self)
        
        // make UITapGestureRecognizer when tapping dummyview which is for fake
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        dummyView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
//        Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(updateAlarmGauge), userInfo: nil, repeats: true)
    }
    
    func updateAlarmGauge() {
        let notification = Notification(name: NSNotification.Name(rawValue: "CustomCellUpdate"), object: nil, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        /* Keyboard Infromation Retrieving */
        let userInfo: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardArea = keyboardFrame.cgRectValue
        return keyboardArea.height
    }
    
    func getColorAlarmSelectionViewFrame(keyboardHeight: CGFloat) -> CGRect {
        return CGRect(x: 0,
                      y: dummyView.frame.height - keyboardHeight - 150 + 80,
                      width: dummyView.frame.width,
                      height: 150)
    }
    
    func getAlarmDateChosingViewFrame(keyboardHeight: CGFloat) -> CGRect {
        let y = colorAlarmSelectionView!.frame.origin.y + colorAlarmSelectionView!.frame.size.height - 10
        let width = dummyView.frame.width
        let height = keyboardHeight + 50

        return CGRect(x: 0, y: y + height, width: width, height: height)
    }
    
    
    func keyboardWillShow(_ notification : Notification){
        let keyboardHeight = getKeyboardHeight(notification: notification)
        
        if colorAlarmSelectionView == nil {
            let frame = getColorAlarmSelectionViewFrame(keyboardHeight: keyboardHeight)
            
            colorAlarmSelectionView = AddSubInfo(frame: frame)
            dummyView.addSubview(colorAlarmSelectionView!)
            colorAlarmSelectionView?.delegate = customDelegateHandler
            colorAlarmSelectionView?.selectedColorIndex = currentWorkingColorIndex
            colorAlarmSelectionView?.alarmCount = currentWorkingAlarms.count
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.colorAlarmSelectionView?.alpha = 1
            })
        }
        
        let frame = getAlarmDateChosingViewFrame(keyboardHeight: keyboardHeight)
        
        if alarmDateChoosingView == nil {
            alarmDateChoosingView = AlarmSubInfo(frame: frame)
            alarmDateChoosingView?.startingDate = currentWorkingStartingDate
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
                self.alarmDateChoosingView?.frame.origin.y = frame.origin.y + frame.height
            })
            
            alarmDateChoosingView?.startingDate = currentWorkingStartingDate
        }
    }
    
    func colorAlarmSelectionViewTapped(_ gesture: UITapGestureRecognizer) { /* do nothing */ }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + 70
        print("scrollViewDidScroll \(offset)")
        
        if offset < 0 {
            if refreshView == nil {
                let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 78)
                refreshView = RefreshView(frame: frame)
                refreshView?.delegate = customDelegateHandler
                
                dummyView.addSubview(refreshView!)
                isInTheMiddleOfEnteringItem = true
                
                refreshView!.titleField.becomeFirstResponder()
                
                currentWorkingStartingDate = Date()
                
                self.view.exchangeSubview(at: 0, withSubviewAt: 1)
            }
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
        self.refreshView?.titleField.endEditing(true)
        
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
                
                self.isInTheMiddleOfEnteringItem = false
                self.isRefreshControlFullyVisible = false
                self.isInTheMiddleOfLongPressing = false
                
                self.currentWorkingAlarms = [Date]()
                self.currentWorkingColorIndex = 0
                self.currentWorkingTitle = ""
                
                self.refreshView?.removeFromSuperview()
                self.refreshView = nil
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dolist.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell") as! ToDoListTableViewCell
        
        let doItem = dolist[indexPath.row]
        
        cell.backgroundColor = UIColor.clear
        cell.item = doItem
        cell.isCrossedOut = doItem.lineflag!.boolValue
        cell.originalTitle = doItem.title
        
        if doItem.lineflag == NSNumber(value: true as Bool) {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (cell.originalTitle)!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.titleLabel.attributedText = attributeString
            cell.isCrossedOut = true
        }
        
        switch doItem.color!.index!.intValue {
        case 0:
            cell.colorButton.backgroundColor = dummyAlarmSelectionView.firstColor.backgroundColor
        case 1:
            cell.colorButton.backgroundColor = dummyAlarmSelectionView.secondColor.backgroundColor
        case 2:
            cell.colorButton.backgroundColor = dummyAlarmSelectionView.thirdColor.backgroundColor
        case 3:
            cell.colorButton.backgroundColor = dummyAlarmSelectionView.fourthColor.backgroundColor
        case 4:
            cell.colorButton.backgroundColor = dummyAlarmSelectionView.fifthColor.backgroundColor
        default:
            print("nothing")
        }
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.cellLongPressed))
        lpgr.minimumPressDuration = 1.0
        cell.addGestureRecognizer(lpgr)
        
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
            (tableView.cellForRow(at: indexPath) as! ToDoListTableViewCell).item = nil
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        });
        deleteAction.backgroundColor = UIColor.white
        
        return [deleteAction]
    }
    
    func cellLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if !isInTheMiddleOfLongPressing {
            
            isInTheMiddleOfLongPressing = true
            
            let touchPoint = gesture.location(in: tableView)
            
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let currentTodoItem = dolist[indexPath.row]
                
                currentWorkingColorIndex = currentTodoItem.color?.index as! Int
                currentWorkingStartingDate = currentTodoItem.startingDate!
                currentWorkingTitle = currentTodoItem.title!
            
                for alarm in currentTodoItem.alarms! {
                    currentWorkingAlarms.append((alarm as! Alarm).alarm!)
                }
                
                let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 78)
                refreshView = RefreshView(frame: frame)
                refreshView?.delegate = customDelegateHandler
                refreshView?.titleField.text = currentWorkingTitle
                
                dummyView.addSubview(refreshView!)
                isInTheMiddleOfEnteringItem = true
                
                refreshView!.titleField.becomeFirstResponder()
                
                currentWorkingStartingDate = Date()
                
                self.view.exchangeSubview(at: 0, withSubviewAt: 1)
            }
        }
    }
    
    func showAlarmDateChoosingView() {
        refreshView?.titleField.endEditing(true)
        
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
    
    func setupInitialItems() {
        var newItem = CoreDataController.sharedInstace.addToDoList(title: "투둥 어플에 오신것을 환영 합니다",
                                                                   startingDate: Date(),
                                                                   alarms: [Date](),
                                                                   colorIndex: 0)
        dolist.append(newItem)
        
        newItem = CoreDataController.sharedInstace.addToDoList(title: "화면을 아래로 내리면, 새로운 아이템 입력이 가능합니다.",
                                                                   startingDate: Date(),
                                                                   alarms: [Date](),
                                                                   colorIndex: 1)
        dolist.append(newItem)

        newItem = CoreDataController.sharedInstace.addToDoList(title: "손가락을 오른쪽으로 밀어내면, 완료 표시가 가능합니다.",
                                                               startingDate: Date(),
                                                               alarms: [Date](),
                                                               colorIndex: 2)
        newItem.lineflag = NSNumber(value: true)
        dolist.append(newItem)

        newItem = CoreDataController.sharedInstace.addToDoList(title: "다시한번 손가락을 오른쪽으로 밀어내면, 완료 표시 해제가 가능합니다.",
                                                               startingDate: Date(),
                                                               alarms: [Date](),
                                                               colorIndex: 2)
        dolist.append(newItem)
        
//        newItem = CoreDataController.sharedInstace.addToDoList(title: "알람은 총 3개까지 추가가 가능합니다.",
//                                                               startingDate: Date(),
//                                                               alarms: [Date](),
//                                                               colorIndex: 3)
//        dolist.append(newItem)
//        
//        let testDate = Date().addingTimeInterval(60)
//        newItem = CoreDataController.sharedInstace.addToDoList(title: "가장 최근의 알람이 가까워 올때, 색이 차오릅니다.",
//                                                               startingDate: Date(),
//                                                               alarms: [testDate],
//                                                               colorIndex: 3)
//        dolist.append(newItem)
 
        newItem = CoreDataController.sharedInstace.addToDoList(title: "손가락을 오른쪽으로 밀어내면, 아이템 삭제가 가능합니다.",
                                                               startingDate: Date(),
                                                               alarms: [Date](),
                                                               colorIndex: 4)
        dolist.append(newItem)
    }
}

