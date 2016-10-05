//
//  AlarmSubInfo.swift
//  to_do
//
//  Created by chansung on 10/4/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit

class AlarmSubInfo: UIView {

    @IBOutlet weak var dayCount: UILabel!
    @IBOutlet weak var dayScrollView: UIScrollView!
    @IBOutlet weak var hourScrollView: UIScrollView!
    @IBOutlet weak var minuteScrollView: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInitialization()
    }
    
    func commonInitialization() {
        let view = NSBundle.mainBundle().loadNibNamed("AlarmSubInfo", owner: self, options: nil).first as! UIView
        view.frame = bounds
        
        dayCount.layer.cornerRadius = 10
        dayCount.layer.masksToBounds = true
        dayCount.layer.borderWidth = 2.0
        dayCount.layer.borderColor = UIColor.grayColor().CGColor
        
        dayScrollView.layer.cornerRadius = 10
        dayScrollView.layer.masksToBounds = true
        dayScrollView.layer.borderWidth = 2.0
        dayScrollView.layer.borderColor = UIColor.grayColor().CGColor

        hourScrollView.layer.cornerRadius = 10
        hourScrollView.layer.masksToBounds = true
        hourScrollView.layer.borderWidth = 2.0
        hourScrollView.layer.borderColor = UIColor.grayColor().CGColor
        
        minuteScrollView.layer.cornerRadius = 10
        minuteScrollView.layer.masksToBounds = true
        minuteScrollView.layer.borderWidth = 2.0
        minuteScrollView.layer.borderColor = UIColor.grayColor().CGColor
        
        dayScrollView.contentSize = CGSize(width: dayScrollView.frame.size.width, height: dayScrollView.frame.size.height * 100)
        
        hourScrollView.contentSize = CGSize(width: hourScrollView.frame.size.width, height: hourScrollView.frame.size.height * 23)
        
        minuteScrollView.contentSize = CGSize(width: minuteScrollView.frame.size.width, height: minuteScrollView.frame.size.height * 59)
        
        for index in 1...100 {
            let label = UILabel(frame: CGRect(x: 0, y: dayScrollView.frame.size.height * CGFloat(index-1), width: dayScrollView.bounds.width, height: dayScrollView.bounds.height))
            label.text = "\(index)"
            label.textAlignment = .Center
            label.font = UIFont.boldSystemFontOfSize(30.0)
            
            dayScrollView.addSubview(label)
        }
        
        for index in 1...23 {
            let label = UILabel(frame: CGRect(x: 0, y: hourScrollView.frame.size.height * CGFloat(index-1), width: hourScrollView.bounds.width, height: hourScrollView.bounds.height))
            label.text = "\(index)"
            label.textAlignment = .Center
            label.font = UIFont.boldSystemFontOfSize(30.0)
            
            hourScrollView.addSubview(label)
        }
        
        for index in 1...59 {
            let label = UILabel(frame: CGRect(x: 0, y: minuteScrollView.frame.size.height * CGFloat(index-1), width: minuteScrollView.bounds.width, height: minuteScrollView.bounds.height))
            label.text = "\(index)"
            label.textAlignment = .Center
            label.font = UIFont.boldSystemFontOfSize(30.0)
            
            minuteScrollView.addSubview(label)
        }
        
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowRadius = 15
        view.layer.shadowOpacity = 0.15
        
        addSubview(view)
    }
}
