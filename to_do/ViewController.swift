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
    
    var dolist = [Dolist]()
    var refreshController = UIRefreshControl()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 65, 0)
        
        dolist = CoreDataController.sharedInstace.loadFromCoredata()
        self.tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        
        print("start test")
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd HH:mm:ss"
        let someDate = formatter.dateFromString("2014-12-25 10:25:00")
        print("somdate  : " + String(someDate))
        
        let colorR = arc4random() % 256
        let colorG = arc4random() % 256
        let colorB = arc4random() % 256
        
        let entityDescription = NSEntityDescription.entityForName("Color", inManagedObjectContext: CoreDataController.sharedInstace.managedObjectContext)
        let color = Color(entity: entityDescription!, insertIntoManagedObjectContext: CoreDataController.sharedInstace.managedObjectContext)
        color.r = NSNumber(unsignedInt: colorR)
        color.g = NSNumber(unsignedInt: colorG)
        color.b = NSNumber(unsignedInt: colorB)
        color.a = NSNumber(unsignedInt: colorB)
        
        CoreDataController.sharedInstace.saveToCoredata("test", deadline: someDate!, color: color)
        
        refreshController.addTarget(self, action: "didRefresh", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshController)
        self.refreshController.backgroundColor = UIColor.darkGrayColor()
        
        
        //CoreDataController.sharedInstace.saveToCoredata("test12", deadline: someDate!, color: color)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func didRefresh() {
        print("start refresh action")
        
        
        //self.refreshController.endRefreshing()
        
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("dolist cont :" + String(dolist.count))
        self.refreshController.addSubview(RefreshView())
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
    
    func cellLongPressed(gesture: UILongPressGestureRecognizer) {
        print("long pressed...")
    }
}

