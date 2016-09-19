//
//  ViewController.swift
//  to_do
//
//  Created by Chansung, Park on 12/09/2016.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var dolist = [Dolist]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        dolist = CoreDataController.sharedInstace.loadFromCoredata()
        self.tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        
//        print("start test")
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "yyyy'-'MM'-'dd HH:mm:ss"
//        let someDate = formatter.dateFromString("2014-12-25 10:25:00")
//        print("somdate  : " + String(someDate))
        
//        var test1 = ToDoItem(title: "test", deadline: someDate!, addingHours: 2, addingMinutes: 30)
//        var test2 = ToDoItem(title: "test12", deadline: someDate!, addingHours: 2, addingMinutes: 30)

//        let controllertest1: CoreDataController = CoreDataController()
//        controllertest1.saveToCoredata(test1)
//        controllertest1.saveToCoredata(test2)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("dolist cont :" + String(dolist.count))
        return dolist.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoListCell") as? ToDoListTableViewCell

        cell?.layer.borderWidth = 1.0
        cell?.colorButton.backgroundColor = UIColor.blueColor()
        cell?.backgroundColor = UIColor.clearColor()
        let doItem = dolist[indexPath.row]
        cell!.titleLabel.text = doItem.title
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.beginUpdates()
            CoreDataController.sharedInstace.removeFromCoreData(dolist[indexPath.row])
            dolist.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
    }
}

