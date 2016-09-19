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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
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
//        CoreDataController.sharedInstace.saveToCoredata("test12", deadline: someDate!, color: color)
        
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
        
        if let color = doItem.color {
            let colorR = CGFloat(color.r!) / 255
            let colorG = CGFloat(color.g!) / 255
            let colorB = CGFloat(color.b!) / 255
        
            let labelColor = UIColor(red:colorR, green: colorG, blue: colorB, alpha: 1)
            cell?.colorButton.backgroundColor = labelColor
        }
        
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

extension NSNumber {
    
    // CGFloat -> NSNumber
    private convenience init(doubleOrFloat d : Double) {
        self.init(double : d)
    }
    private convenience init(doubleOrFloat f : Float) {
        self.init(float : f)
    }
    convenience init(cgFloat : CGFloat) {
        self.init(doubleOrFloat: cgFloat.native)
    }
    
    // NSNumber -> CGFloat
    private func doubleOrFloatValue() -> Double {
        return self.doubleValue
    }
    private func doubleOrFloatValue() -> Float {
        return self.floatValue
    }
    var cgFloatValue : CGFloat {
        return CGFloat(floatLiteral: doubleOrFloatValue())
    }
}

