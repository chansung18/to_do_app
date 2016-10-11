//
//  AddSubInfo.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/25/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit

protocol AddSubInfoDelegate {
    func addAlarmClicked()
    func confirmAlarmClicked(alarmIndex: Int)
    func colorSelectionClicked(color: UIColor)
}

class AddSubInfo: UIView {
    var keyboardHeight:CGFloat?
    
    @IBOutlet weak var firstColor: UIButton!
    @IBOutlet weak var secondColor: UIButton!
    @IBOutlet weak var thirdColor: UIButton!
    @IBOutlet weak var fourthColor: UIButton!
    @IBOutlet weak var fifthColor: UIButton!
    
    @IBOutlet weak var alarmAddButton: UIButton!
    @IBOutlet weak var alarmComfirmButton: UIButton!
    
    @IBOutlet weak var firstAlarmBack: UIButton!
    @IBOutlet weak var secondAlarmBack: UIButton!
    @IBOutlet weak var thirdAlarmBack: UIButton!
    
    @IBOutlet weak var firstAlarmLabel: UIButton!
    @IBOutlet weak var secondAlarmLabel: UIButton!
    @IBOutlet weak var thirdAlarmLabel: UIButton!
    
    @IBOutlet weak var firstAlarmDday: UILabel!
    @IBOutlet weak var secondAlarmDday: UILabel!
    @IBOutlet weak var thirdAlarmDday: UILabel!
    
    @IBOutlet weak var firstColorSelection: UIButton!
    @IBOutlet weak var secondColorSelection: UIButton!
    @IBOutlet weak var thirdColorSelection: UIButton!
    @IBOutlet weak var fourthColorSelection: UIButton!
    @IBOutlet weak var fifthColorSelection: UIButton!
    
    var selectedColorIndex = 0 {
        willSet(newColorIndex) {
            if newColorIndex != selectedColorIndex {
                animateColorSelection(false)
            }
        }
        
        didSet(newColorIndex) {
            if newColorIndex != selectedColorIndex {
                animateColorSelection(true)
            }
        }
    }
    
    var delegate: AddSubInfoDelegate?
    
    var alarmAddButtonToggle = false {
        didSet {
            //add
            if alarmAddButtonToggle {
                alarmAddButton.setImage(UIImage(named: "delete"), forState: .Normal)
                alarmAddButton.setImage(UIImage(named: "delete"), forState: .Selected)
                alarmComfirmButton.alpha = 1
                alarmComfirmButton.userInteractionEnabled = true
            }
            //delete
            else {
                alarmAddButton.setImage(UIImage(named: "alarm_add"), forState: .Normal)
                alarmAddButton.setImage(UIImage(named: "alarm_add"), forState: .Selected)
                alarmComfirmButton.alpha = 0.6
                alarmComfirmButton.userInteractionEnabled = false
            }
        }
    }
    
    var currentSelectedAlarmIndex = 0 {
        willSet(newAlarmIndex) {
            if newAlarmIndex != currentSelectedAlarmIndex {
                animateAlarmSelection(false)
            }
        }
        
        didSet(newAlarmIndex) {
            if newAlarmIndex != currentSelectedAlarmIndex {
                animateAlarmSelection(true)
            }
        }
    }
    
    var alarmCount = 0 {
        didSet {
            if alarmCount < 4 {
                setVisibleAlarmItems()
            }
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
        let view = NSBundle.mainBundle().loadNibNamed("AddSubInfo", owner: self, options: nil).first as! UIView
        
        view.frame = bounds
        
        firstColorSelection.layer.cornerRadius = firstColor.frame.width / 2.0
        firstColorSelection.layer.masksToBounds = true
        firstColorSelection.layer.borderWidth = 3.0
        firstColorSelection.layer.borderColor = UIColor.cyanColor().CGColor
       
        secondColorSelection.layer.cornerRadius = secondColor.frame.width / 2.0
        secondColorSelection.layer.masksToBounds = true
        secondColorSelection.layer.borderWidth = 3.0
        secondColorSelection.layer.borderColor = UIColor.cyanColor().CGColor
        
        thirdColorSelection.layer.cornerRadius = thirdColor.frame.width / 2.0
        thirdColorSelection.layer.masksToBounds = true
        thirdColorSelection.layer.borderWidth = 3.0
        thirdColorSelection.layer.borderColor = UIColor.cyanColor().CGColor
        
        fourthColorSelection.layer.cornerRadius = fourthColor.frame.width / 2.0
        fourthColorSelection.layer.masksToBounds = true
        fourthColorSelection.layer.borderWidth = 3.0
        fourthColorSelection.layer.borderColor = UIColor.cyanColor().CGColor
        
        fifthColorSelection.layer.cornerRadius = fifthColor.frame.width / 2.0
        fifthColorSelection.layer.masksToBounds = true
        fifthColorSelection.layer.borderWidth = 3.0
        fifthColorSelection.layer.borderColor = UIColor.cyanColor().CGColor
        
        firstColor.layer.cornerRadius = firstColor.frame.width / 2.0
        firstColor.layer.masksToBounds = true

        secondColor.layer.cornerRadius = secondColor.frame.width / 2.0
        secondColor.layer.masksToBounds = true
        
        thirdColor.layer.cornerRadius = thirdColor.frame.width / 2.0
        thirdColor.layer.masksToBounds = true
        
        fourthColor.layer.cornerRadius = fourthColor.frame.width / 2.0
        fourthColor.layer.masksToBounds = true
        
        fifthColor.layer.cornerRadius = fifthColor.frame.width / 2.0
        fifthColor.layer.masksToBounds = true
        
        
        firstAlarmBack.layer.cornerRadius = 13
        firstAlarmBack.layer.borderWidth = 2.0
        firstAlarmBack.layer.borderColor = UIColor.grayColor().CGColor
        
        secondAlarmBack.layer.cornerRadius = 13
        secondAlarmBack.layer.borderWidth = 2.0
        secondAlarmBack.layer.borderColor = UIColor.grayColor().CGColor
        
        thirdAlarmBack.layer.cornerRadius = 13
        thirdAlarmBack.layer.borderWidth = 2.0
        thirdAlarmBack.layer.borderColor = UIColor.grayColor().CGColor
        
        firstAlarmLabel.layer.cornerRadius = firstAlarmLabel.frame.width / 2.0
        firstAlarmLabel.layer.masksToBounds = true
        
        secondAlarmLabel.layer.cornerRadius = secondAlarmLabel.frame.width / 2.0
        secondAlarmLabel.layer.masksToBounds = true
        
        thirdAlarmLabel.layer.cornerRadius = thirdAlarmLabel.frame.width / 2.0
        thirdAlarmLabel.layer.masksToBounds = true
        
        view.layer.cornerRadius = 15
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 15
        view.layer.shadowColor = UIColor.blackColor().CGColor
        
        addSubview(view)
    }
    
    func setVisibleAlarmItems() {
        if alarmCount >= 0 {
            firstAlarmBack.alpha = 0.2
            firstAlarmLabel.alpha = 0.2
            firstAlarmDday.alpha = 0.2
            
            secondAlarmBack.alpha = 0.2
            secondAlarmLabel.alpha = 0.2
            secondAlarmDday.alpha = 0.2
            
            thirdAlarmBack.alpha = 0.2
            thirdAlarmLabel.alpha = 0.2
            thirdAlarmDday.alpha = 0.2
        }
        
        if alarmCount >= 1 {
            firstAlarmBack.alpha = 1
            firstAlarmLabel.alpha = 1
            firstAlarmDday.alpha = 1
            
            secondAlarmBack.alpha = 0.2
            secondAlarmLabel.alpha = 0.2
            secondAlarmDday.alpha = 0.2
            
            thirdAlarmBack.alpha = 0.2
            thirdAlarmLabel.alpha = 0.2
            thirdAlarmDday.alpha = 0.2
        }
        
        if alarmCount >= 2 {
            secondAlarmBack.alpha = 1
            secondAlarmLabel.alpha = 1
            secondAlarmDday.alpha = 1
            
            thirdAlarmBack.alpha = 0.2
            thirdAlarmLabel.alpha = 0.2
            thirdAlarmDday.alpha = 0.2
        }
        
        if alarmCount >= 3 {
            thirdAlarmBack.alpha = 1
            thirdAlarmLabel.alpha = 1
            thirdAlarmDday.alpha = 1
        }
    }
    
    func animateColorSelection(appear: Bool) {
        UIView.animateWithDuration(0.7) {
            switch self.selectedColorIndex {
            case 0:
                self.firstColorSelection.alpha = appear ? 1.0 : 0.0
            case 1:
                self.secondColorSelection.alpha = appear ? 1.0 : 0.0
            case 2:
                self.thirdColorSelection.alpha = appear ? 1.0 : 0.0
            case 3:
                self.fourthColorSelection.alpha = appear ? 1.0 : 0.0
            case 4:
                self.fifthColorSelection.alpha = appear ? 1.0 : 0.0
            default:
                print("")
            }
        }
    }
    
    func animateAlarmSelection(appear: Bool) {
        UIView.animateWithDuration(0.7) { 
            switch self.currentSelectedAlarmIndex {
            case 1:
                self.firstAlarmBack.layer.borderColor = appear ? UIColor.cyanColor().CGColor : UIColor.grayColor().CGColor
            case 2:
                self.secondAlarmBack.layer.borderColor = appear ? UIColor.cyanColor().CGColor : UIColor.grayColor().CGColor
            case 3:
                self.thirdAlarmBack.layer.borderColor = appear ? UIColor.cyanColor().CGColor : UIColor.grayColor().CGColor
            default:
                print("")
            }
        }
    }
    
    @IBAction func colorClicked(sender: UIButton) {
        selectedColorIndex = sender.tag
        delegate?.colorSelectionClicked(sender.backgroundColor!)
    }
    
    @IBAction func alarmAddClicked(sender: UIButton) {
        print(".....count ? \(alarmCount)")
        
        if alarmCount < 3 {
            delegate?.addAlarmClicked()
            alarmAddButtonToggle = !alarmAddButtonToggle
        }
    }
    
    @IBAction func confirmAlarmClicked(sender: UIButton) {
        delegate?.confirmAlarmClicked(currentSelectedAlarmIndex)
        
        alarmAddClicked(sender)
        alarmCount = alarmCount+1
        
        alarmComfirmButton.alpha = 0.6
        alarmComfirmButton.userInteractionEnabled = false
        
        if alarmCount >= 3 {
            alarmAddButtonToggle = false
            alarmAddButton.alpha = 0.6
            alarmAddButton.userInteractionEnabled = false
            thirdAlarmBack.layer.borderColor = UIColor.grayColor().CGColor
        }
    }
}
