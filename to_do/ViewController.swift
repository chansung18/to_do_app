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
                      UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dummyView: UIView!
    
    var customDelegateHandler: CustomDelegateActionHandlers!
    
    var currentWorkingTitle: String = String()
    var currentWorkingColorIndex: Int = 0
    var currentWorkingColor: UIColor = UIColor.gray
    var currentWorkingAlarms: [Date] = [Date]()
    var currentWorkingStartingDate: Date = Date()
    
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
        
        customDelegateHandler = CustomDelegateActionHandlers(viewController: self)
        
        //make UITapGestureRecognizer when tapping dummyview which is for fake
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        dummyView.addGestureRecognizer(tapGesture)
        
        refreshController.alpha = 0.0
        
        refreshController.frame.size.width = view.frame.size.width
        refreshController.tintColor = UIColor.clear
        subviewitem.delegate = customDelegateHandler
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
        /*Keyboard Infromation Retrieving*/
        let userInfo:NSDictionary = (nofification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        if keyboardSubView == nil {
            keyboardSubView = AddSubInfo(frame: CGRect(x: 0,
                                                   y: dummyView.frame.height - keyboardHeight - 150,
                                                   width: dummyView.frame.width,
                                                   height: 150))
            keyboardSubView?.delegate = customDelegateHandler
            keyboardSubView?.selectedColorIndex = currentWorkingColorIndex
            keyboardSubView?.alarmCount = currentWorkingAlarms.count
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
        self.keyboardSubView?.delegate = customDelegateHandler
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
        
        currentWorkingStartingDate = Date()
        currentWorkingAlarms = [Date]()
        currentWorkingColorIndex = 0
        currentWorkingColor = UIColor.gray
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
        },
        completion: { (completed) in
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

        let doItem = dolist[(indexPath as NSIndexPath).row]
        
        cell?.backgroundColor = UIColor.clear
        cell?.originalTitle = doItem.title
        cell?.index = (indexPath as NSIndexPath).row
        cell?.delegate = customDelegateHandler
        
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
        
        let currentTodoItem = dolist[indexPath.row]
        
        let editAction = UITableViewRowAction(style: .normal, title: "🖊", handler:{ action, indexpath in
            //edit Action codes
            self.didRefresh()
            self.subviewitem.titleField.text = currentTodoItem.title
            self.currentWorkingColorIndex = currentTodoItem.color?.index as! Int
            self.currentWorkingStartingDate = currentTodoItem.startingDate!
            
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
}

