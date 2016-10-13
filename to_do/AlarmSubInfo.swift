//
//  AlarmSubInfo.swift
//  to_do
//
//  Created by chansung on 10/4/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit

protocol AlarmSubinfoDelegate {
    func alarmChanged()
}

class AlarmSubInfo: UIView, UIScrollViewDelegate {

    @IBOutlet weak var dayCount: UILabel!
    @IBOutlet weak var dayScrollView: UIScrollView!
    @IBOutlet weak var hourScrollView: UIScrollView!
    @IBOutlet weak var minuteScrollView: UIScrollView!
    var delegate: AlarmSubinfoDelegate?
    
    var day: Int = 0 {
        didSet {
            animateDayScrollView()
            setAlarmDate()
        }
    }
    
    var hour: Int = 0 {
        didSet {
            animateHourScrollView()
            setAlarmDate()
        }
    }
    
    var minute: Int = 0 {
        didSet {
            animateMinuteScrollView()
            setAlarmDate()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInitialization()
    }
    
    func commonInitialization() {
        let view = Bundle.main.loadNibNamed("AlarmSubInfo", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        
        setAlarmDate()
        
        dayCount.layer.cornerRadius = 10
        dayCount.layer.masksToBounds = true
        dayCount.layer.borderWidth = 2.0
        dayCount.layer.borderColor = UIColor.lightGray.cgColor
        
        dayScrollView.delegate = self
        dayScrollView.layer.cornerRadius = 10
        dayScrollView.layer.masksToBounds = true
        dayScrollView.layer.borderWidth = 2.0
        dayScrollView.layer.borderColor = UIColor.lightGray.cgColor

        hourScrollView.delegate = self
        hourScrollView.layer.cornerRadius = 10
        hourScrollView.layer.masksToBounds = true
        hourScrollView.layer.borderWidth = 2.0
        hourScrollView.layer.borderColor = UIColor.lightGray.cgColor
        
        minuteScrollView.delegate = self
        minuteScrollView.layer.cornerRadius = 10
        minuteScrollView.layer.masksToBounds = true
        minuteScrollView.layer.borderWidth = 2.0
        minuteScrollView.layer.borderColor = UIColor.lightGray.cgColor
        
        dayScrollView.contentSize = CGSize(width: dayScrollView.frame.size.width,
                                           height: dayScrollView.frame.size.height * 101)
        
        hourScrollView.contentSize = CGSize(width: hourScrollView.frame.size.width,
                                            height: hourScrollView.frame.size.height * 24)
        
        minuteScrollView.contentSize = CGSize(width: minuteScrollView.frame.size.width,
                                              height: minuteScrollView.frame.size.height * 60)
        
        for index in 0...100 {
            let label = UILabel(frame: CGRect(x: 0,
                                              y: dayScrollView.frame.size.height * CGFloat(index),
                                              width: dayScrollView.bounds.width,
                                              height: dayScrollView.bounds.height))
            label.text = "\(index)"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 45.0)
            
            dayScrollView.addSubview(label)
        }
        
        for index in 0...23 {
            let label = UILabel(frame: CGRect(x: 0,
                                              y: hourScrollView.frame.size.height * CGFloat(index),
                                              width: hourScrollView.bounds.width,
                                              height: hourScrollView.bounds.height))
            label.text = "\(index)"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 45.0)
            
            hourScrollView.addSubview(label)
        }
        
        for index in 0...59 {
            let label = UILabel(frame: CGRect(x: 0,
                                              y: minuteScrollView.frame.size.height * CGFloat(index),
                                              width: minuteScrollView.bounds.width,
                                              height: minuteScrollView.bounds.height))
            label.text = "\(index)"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 45.0)
            
            minuteScrollView.addSubview(label)
        }
        
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 15
        view.layer.shadowOpacity = 0.15
        
        addSubview(view)
    }
    
    func animateDayScrollView() {
        dayScrollView.scrollRectToVisible(CGRect(x: 0,
                                                 y: dayScrollView.frame.size.height * CGFloat(day),
                                                 width: dayScrollView.bounds.width,
                                                 height: dayScrollView.bounds.height),
                                          animated: true)
        delegate?.alarmChanged()
    }
    
    func animateHourScrollView() {
        hourScrollView.scrollRectToVisible(CGRect(x: 0,
                                                  y: hourScrollView.frame.size.height * CGFloat(hour),
                                                  width: hourScrollView.bounds.width,
                                                  height: hourScrollView.bounds.height),
                                           animated: true)
    }
    
    func animateMinuteScrollView() {
        minuteScrollView.scrollRectToVisible(CGRect(x: 0,
                                                    y: minuteScrollView.frame.size.height * CGFloat(minute),
                                                    width: minuteScrollView.bounds.width,
                                                    height: minuteScrollView.bounds.height),
                                             animated: true)
    }
    
    //scrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset
        let index = Int(offSet.y / scrollView.frame.size.height)
        
        //day Scroll View
        if scrollView.tag == 0 {
            day = index
            print("day \(day)")
        }
        //hour Scroll View
        else if scrollView.tag == 1 {
            hour = index
            print("hour \(hour)")
        }
        //Minute Scroll View
        else if scrollView.tag == 2 {
            minute = index
            print("minute \(minute)")
        }
        
        setAlarmDate()
    }
    
    func setAlarmDate() {
        let currentTime = Date()
        
        let dayInSeconds = day * 24 * 60 * 60
        let hourInSeconds = hour * 60 * 60
        let minuteInSeconds = minute * 60
        let alarmTime = currentTime.addingTimeInterval(Double(dayInSeconds + hourInSeconds + minuteInSeconds))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm"
        dayCount.text = dateFormatter.string(from: alarmTime)
        delegate?.alarmChanged()
    }
    func getAlarmDate()-> Date{
        let currentTime = Date()
        let dayInSeconds = day * 24 * 60 * 60
        let hourInSeconds = hour * 60 * 60
        let minuteInSeconds = minute * 60
        let alarmTime = currentTime.addingTimeInterval(Double(dayInSeconds + hourInSeconds + minuteInSeconds))
        
        return alarmTime
    }
}
