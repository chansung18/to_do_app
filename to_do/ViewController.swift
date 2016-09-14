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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("start test")
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd HH:mm:ss"
        let someDate = formatter.dateFromString("2014-12-25 10:25:00")
        print("somdate  : " + String(someDate))
        
        var test1 = ToDoItem(title: "test", deadline: someDate!, addingHours: 2, addingMinutes: 30)
        
        let controllertest1: CoreDataController = CoreDataController()
        controllertest1.saveToCoredata(test1)
        controllertest1.loadFromCoredata()
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoListCell") as? ToDoListTableViewCell
//        let cell = tableView.dequeueReusableCellWithIdentifier("todoListCell", forIndexPath: indexPath) as? ToDoListTableViewCell
        cell?.layer.borderWidth = 1.0
        cell?.colorButton.backgroundColor = UIColor.blueColor()
        cell?.titleLabel.text = "Test Message"
        cell?.backgroundColor = UIColor.clearColor()
        
//        print(cell)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
}

