//
//  AddSubInfo.swift
//  to_do
//
//  Created by Eunkyo, Seo on 9/25/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit

protocol AddSubInfoDelegate {
    func addAlarmClicked(_ addAction: Bool)
    func confirmAlarmClicked(_ alarmIndex: Int)
    func colorSelectionClicked(_ color: UIColor)
    func alarmSelectionClicked(_ alarmIndex: Int, appear: Bool)
    
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
                alarmAddButton.setImage(UIImage(named: "delete"), for: UIControlState())
                alarmAddButton.setImage(UIImage(named: "delete"), for: .selected)
                alarmComfirmButton.alpha = 1
                alarmComfirmButton.isUserInteractionEnabled = true
            }
            //delete
            else {
                alarmAddButton.setImage(UIImage(named: "alarm_add"), for: UIControlState())
                alarmAddButton.setImage(UIImage(named: "alarm_add"), for: .selected)
                alarmComfirmButton.alpha = 0.6
                alarmComfirmButton.isUserInteractionEnabled = false
            }
        }
    }
    var selectedAlarmArray = Array(repeating:false, count:4)
    
    var currentSelectedAlarmIndex = -1 {
        willSet(newAlarmIndex) {
            animateAlarmSelection(false)
        }
        
        didSet(newAlarmIndex) {
            if newAlarmIndex != currentSelectedAlarmIndex {
                animateAlarmSelection(true)
                alarmAddButtonToggle = true
                
                alarmAddButton.alpha = 1
                alarmAddButton.isUserInteractionEnabled = true
            }
            else {
                currentSelectedAlarmIndex = -1
                alarmAddButtonToggle = false
                
                if alarmCount >= 3 {
                    alarmAddButton.alpha = 0.6
                    alarmAddButton.isUserInteractionEnabled = false
                }
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
        let view = Bundle.main.loadNibNamed("AddSubInfo", owner: self, options: nil)?.first as! UIView
        
        view.frame = bounds
        
        firstColorSelection.layer.cornerRadius = firstColor.frame.width / 2.0
        firstColorSelection.layer.masksToBounds = true
        firstColorSelection.layer.borderWidth = 3.0
        firstColorSelection.layer.borderColor = UIColor.cyan.cgColor
       
        secondColorSelection.layer.cornerRadius = secondColor.frame.width / 2.0
        secondColorSelection.layer.masksToBounds = true
        secondColorSelection.layer.borderWidth = 3.0
        secondColorSelection.layer.borderColor = UIColor.cyan.cgColor
        
        thirdColorSelection.layer.cornerRadius = thirdColor.frame.width / 2.0
        thirdColorSelection.layer.masksToBounds = true
        thirdColorSelection.layer.borderWidth = 3.0
        thirdColorSelection.layer.borderColor = UIColor.cyan.cgColor
        
        fourthColorSelection.layer.cornerRadius = fourthColor.frame.width / 2.0
        fourthColorSelection.layer.masksToBounds = true
        fourthColorSelection.layer.borderWidth = 3.0
        fourthColorSelection.layer.borderColor = UIColor.cyan.cgColor
        
        fifthColorSelection.layer.cornerRadius = fifthColor.frame.width / 2.0
        fifthColorSelection.layer.masksToBounds = true
        fifthColorSelection.layer.borderWidth = 3.0
        fifthColorSelection.layer.borderColor = UIColor.cyan.cgColor
        
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
        firstAlarmBack.layer.borderColor = UIColor.gray.cgColor
        
        secondAlarmBack.layer.cornerRadius = 13
        secondAlarmBack.layer.borderWidth = 2.0
        secondAlarmBack.layer.borderColor = UIColor.gray.cgColor
        
        thirdAlarmBack.layer.cornerRadius = 13
        thirdAlarmBack.layer.borderWidth = 2.0
        thirdAlarmBack.layer.borderColor = UIColor.gray.cgColor
        
        firstAlarmLabel.layer.cornerRadius = firstAlarmLabel.frame.width / 2.0
        firstAlarmLabel.layer.masksToBounds = true
        
        secondAlarmLabel.layer.cornerRadius = secondAlarmLabel.frame.width / 2.0
        secondAlarmLabel.layer.masksToBounds = true
        
        thirdAlarmLabel.layer.cornerRadius = thirdAlarmLabel.frame.width / 2.0
        thirdAlarmLabel.layer.masksToBounds = true
        
        view.layer.cornerRadius = 15
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        
        addSubview(view)
    }
    
    func setVisibleAlarmItems() {
        if alarmCount >= 0 {
            firstAlarmBack.alpha = 0.2
            firstAlarmLabel.alpha = 0.2
            firstAlarmDday.alpha = 0.2
            firstAlarmBack.isUserInteractionEnabled = false
            firstAlarmLabel.isUserInteractionEnabled = false
            
            secondAlarmBack.alpha = 0.2
            secondAlarmLabel.alpha = 0.2
            secondAlarmDday.alpha = 0.2
            secondAlarmBack.isUserInteractionEnabled = false
            secondAlarmLabel.isUserInteractionEnabled = false
            
            thirdAlarmBack.alpha = 0.2
            thirdAlarmLabel.alpha = 0.2
            thirdAlarmDday.alpha = 0.2
            thirdAlarmBack.isUserInteractionEnabled = false
            thirdAlarmLabel.isUserInteractionEnabled = false
        }
        
        if alarmCount >= 1 {
            firstAlarmBack.alpha = 1
            firstAlarmLabel.alpha = 1
            firstAlarmDday.alpha = 1
            firstAlarmBack.isUserInteractionEnabled = true
            firstAlarmLabel.isUserInteractionEnabled = true
            
            secondAlarmBack.alpha = 0.2
            secondAlarmLabel.alpha = 0.2
            secondAlarmDday.alpha = 0.2
            secondAlarmBack.isUserInteractionEnabled = false
            secondAlarmLabel.isUserInteractionEnabled = false
            
            thirdAlarmBack.alpha = 0.2
            thirdAlarmLabel.alpha = 0.2
            thirdAlarmDday.alpha = 0.2
            thirdAlarmBack.isUserInteractionEnabled = false
            thirdAlarmLabel.isUserInteractionEnabled = false
        }
        
        if alarmCount >= 2 {
            secondAlarmBack.alpha = 1
            secondAlarmLabel.alpha = 1
            secondAlarmDday.alpha = 1
            secondAlarmBack.isUserInteractionEnabled = true
            secondAlarmLabel.isUserInteractionEnabled = true
            
            thirdAlarmBack.alpha = 0.2
            thirdAlarmLabel.alpha = 0.2
            thirdAlarmDday.alpha = 0.2
            thirdAlarmBack.isUserInteractionEnabled = false
            thirdAlarmLabel.isUserInteractionEnabled = false
        }
        
        if alarmCount >= 3 {
            thirdAlarmBack.alpha = 1
            thirdAlarmLabel.alpha = 1
            thirdAlarmDday.alpha = 1
            thirdAlarmBack.isUserInteractionEnabled = true
            thirdAlarmLabel.isUserInteractionEnabled = true
        }
    }
    
    func animateColorSelection(_ appear: Bool) {
        UIView.animate(withDuration: 0.7, animations: {
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
        }) 
    }
    func getcurrentSelectedAlarmIndexArray() -> Bool {
        print("getcurrentSelectedAlarmIndexArray"  ,currentSelectedAlarmIndex )
        if currentSelectedAlarmIndex >= 0 {
            return self.selectedAlarmArray[currentSelectedAlarmIndex+1]
        }else{
            return false
        }
    }
    func getcurrentSelectedAlarmIndex() -> Int {
        return self.currentSelectedAlarmIndex
    }
    func animateAlarmSelection(_ appear: Bool) {
        UIView.animate(withDuration: 0.7, animations: { 
            switch self.currentSelectedAlarmIndex {
            case 0:
                self.firstAlarmBack.layer.borderColor = appear ? UIColor.cyan.cgColor : UIColor.gray.cgColor
            case 1:
                self.secondAlarmBack.layer.borderColor = appear ? UIColor.cyan.cgColor : UIColor.gray.cgColor
            case 2:
                self.thirdAlarmBack.layer.borderColor = appear ? UIColor.cyan.cgColor : UIColor.gray.cgColor
            default:
                print("")
            }
        }) 
    }
    
    @IBAction func colorClicked(_ sender: UIButton) {
        selectedColorIndex = sender.tag
        delegate?.colorSelectionClicked(sender.backgroundColor!)
    }
    
    @IBAction func alarmAddClicked(_ sender: UIButton) {
        print(".....count ? \(alarmCount)")
        
        if alarmCount < 3 {
            alarmAddButtonToggle = !alarmAddButtonToggle
            delegate?.addAlarmClicked(alarmAddButtonToggle)
            print("alarmAddButtonToggle  :  ", alarmAddButtonToggle)
        }
        if alarmAddButtonToggle == false {
            alarmComfirmButton.alpha = 0.3
            alarmComfirmButton.isEnabled = false
            alarmAddButton.alpha = 1.0
        }else{
            alarmComfirmButton.alpha = 1.0
            alarmComfirmButton.isEnabled = true
            alarmAddButton.alpha = 0.3
        }
    }
    
    @IBAction func confirmAlarmClicked(_ sender: UIButton) {
        delegate?.confirmAlarmClicked(currentSelectedAlarmIndex)
        
        alarmAddClicked(sender)
        alarmCount = alarmCount+1
        print("alarmCount = alarmCount+1  :  " , alarmCount)
        self.selectedAlarmArray[alarmCount] = true
        print("electedAlarmArray[alarmCount]" , selectedAlarmArray[alarmCount])
        alarmComfirmButton.alpha = 0.6
        alarmComfirmButton.isUserInteractionEnabled = false
    

        
        if alarmCount >= 3 {
            alarmAddButtonToggle = false
            alarmAddButton.alpha = 0.6
            alarmAddButton.isUserInteractionEnabled = false
            thirdAlarmBack.layer.borderColor = UIColor.gray.cgColor
        }
        
        currentSelectedAlarmIndex = -1
    }
    
    @IBAction func alarmClicked(_ sender: UIButton) {
        currentSelectedAlarmIndex = sender.tag
        if alarmAddButtonToggle {
            alarmComfirmButton.alpha = 0.3
            alarmComfirmButton.isEnabled = false
        }else{
            alarmComfirmButton.alpha = 1.0
            alarmComfirmButton.isEnabled = true
        }
        delegate?.alarmSelectionClicked(sender.tag, appear: currentSelectedAlarmIndex != -1 )
        
    }
}
