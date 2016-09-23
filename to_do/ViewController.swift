//
//  ViewController.swift
//  to_do
//
//  Created by Chansung, Park on 12/09/2016.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dummyView: UIView!
    
    var dolist = [Dolist]()
    var refreshController = UIRefreshControl()
    
    let subviewitem : RefreshView = RefreshView()
    
    var isInTheMiddleOfEnteringItem: Bool = false
    var isRefreshControlFullyVisible: Bool = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 65, 0)
        
        dolist = CoreDataController.sharedInstace.loadFromCoredata()
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        dummyView.addGestureRecognizer(tapGesture)
        
        refreshController.alpha = 0.0
        
        refreshController.frame.size.width = view.frame.size.width
        refreshController.tintColor = UIColor.clearColor()
        
        subviewitem.mainViewController = self
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
        
        tableView.addSubview(refreshController)
    }
    
    func didRefresh() {
        showRefreshControl()
        print("start refresh action")
        
        subviewitem.titleField.becomeFirstResponder()
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
        
        print("alpha = \(refreshController.alpha)")
    }
    
    func tableViewTapped(gesture: UITapGestureRecognizer) {
        print("tapped...")
        if isInTheMiddleOfEnteringItem {
            dismissRefreshControl()
        }
    }

    func dismissRefreshControl() {
        UIView.animateWithDuration(0.5) {
            self.view.exchangeSubviewAtIndex(0, withSubviewAtIndex: 1)
        }
        
        UIView.animateWithDuration(0.5) { 
            self.refreshController.alpha = 0.0
        }
    
        subviewitem.titleField.endEditing(true)
        refreshController.endRefreshing()
        isInTheMiddleOfEnteringItem = false
        isRefreshControlFullyVisible = false
    }
    
    func showRefreshControl() {
//        self.refreshController.alpha = 1
        
        UIView.animateWithDuration(0.5) {
            self.view.exchangeSubviewAtIndex(0, withSubviewAtIndex: 1)
        }
        
        isInTheMiddleOfEnteringItem = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("dolist cont :" + String(dolist.count))

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
        cell!.titleLabel.text = doItem.title
        cell!.originalTitle = doItem.title
        
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
        
        return [deleteAction, editAction];
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        (tableView.cellForRowAtIndexPath(indexPath) as! ToDoListTableViewCell).isEditingMode = false
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("cell selection")
    }
    
    func cellLongPressed(gesture: UILongPressGestureRecognizer) {
        print("long pressed...")
    }
}

