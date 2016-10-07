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
    
    @IBOutlet weak var firstColorSelection: UIButton!
    @IBOutlet weak var secondColorSelection: UIButton!
    @IBOutlet weak var thirdColorSelection: UIButton!
    @IBOutlet weak var fourthColorSelection: UIButton!
    @IBOutlet weak var fifthColorSelection: UIButton!
    
    var selectedColorIndex = 0
    var delegate: AddSubInfoDelegate?
    
    var alarmAddButtonToggle = false
    
//    var selectedColor: colorSelection = .first
    
//    enum colorSelection {
//        case first
//        case second
//        case third
//        case fourth
//        case fifth
//    }
    
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
        
        alarmAddButton.layer.cornerRadius = alarmAddButton.frame.width / 2.0
        alarmAddButton.layer.masksToBounds = true
        alarmAddButton.layer.borderWidth = 2.0
        alarmAddButton.layer.borderColor = UIColor.grayColor().CGColor
        
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
    
    func selectColor(selection: Int) {
        if selection != selectedColorIndex {
            animateColorSelection(false)
            selectedColorIndex = selection
            animateColorSelection(true)
        }
    }
    func setAlarmComfirmbutton(tempString : String) {
        self.alarmComfirmButton.setTitle(tempString, forState: UIControlState.Normal)
    }
    
    
    @IBAction func colorClicked(sender: UIButton) {
        print("tag = \(sender.tag)")
        
        selectColor(sender.tag)
    }
    
    @IBAction func alarmAddClicked(sender: UIButton) {
        delegate?.addAlarmClicked()
        
        alarmAddButtonToggle = !alarmAddButtonToggle
        
        print("\(alarmAddButtonToggle)")
        
        if alarmAddButtonToggle {
            alarmAddButton.setTitle("×", forState: .Selected)
            alarmAddButton.setTitle("×", forState: .Normal)
        }
        else {
            alarmAddButton.setTitle("+", forState: .Normal)
            alarmAddButton.setTitle("+", forState: .Selected)
        }
        
        print("\(alarmAddButton.titleLabel?.text)")
    }
    
}
