//
//  ToDoListTableViewCell.swift
//  to_do
//
//  Created by chansung on 9/13/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit

class ToDoListTableViewCell: UITableViewCell {
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var item: Dolist? {
        didSet(newItem) {
            if let newItem = newItem {
                originalTitle = newItem.title!
                isCrossedOut = newItem.lineflag!.boolValue
            }
        }
    }
    
    var index: Int = 0
    
    var directionOfRight: Bool = false
    var tableView: UITableView?
    
    var isEditingMode: Bool = true
    var isPanGestureStarted: Bool = false
    var isMultiGestureAllowed: Bool = true
    var isInTheMiddleOfCrossingOut: Bool = false
    var startY: CGFloat = 0
    var endY: CGFloat = 0
    
    var isCrossedOut: Bool = false {
        didSet {
            item?.lineflag = NSNumber(value: isCrossedOut)
        }
    }
    
    var originalTitle: String? {
        didSet {
            titleLabel.text = originalTitle
            item?.title = originalTitle
        }
    } 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        
        colorButton.layer.cornerRadius = colorButton.bounds.width / 2.0
        colorButton.layer.masksToBounds = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanned))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func didPanned(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            isPanGestureStarted = true
            startY = gesture.translation(in: self.tableView).y
        }
        
        else if gesture.state == .changed {
            endY = gesture.translation(in: self.tableView).y
            
            if abs(endY-startY) > 0 && !isInTheMiddleOfCrossingOut {
                isMultiGestureAllowed = false
                isEditingMode = false
            }
            else if abs(endY-startY) > 5 && isPanGestureStarted {
                isEditingMode = false
            }
            else if gesture.velocity(in: self).x < 0 && isPanGestureStarted {
                isEditingMode = false
            }
            
            isPanGestureStarted = false
            
            if isEditingMode {
                if gesture.location(in: self).x > 0 {
                    isInTheMiddleOfCrossingOut = true
                    
                    if isCrossedOut == false {
                        let titleLength = originalTitle!.characters.count
                        
                        var tmpIndex = 0
                        
                        if titleLength > 10 {
                            tmpIndex = Int(gesture.location(in: self).x * 5 / CGFloat(titleLength)) - 10
                        }
                        else {
                            tmpIndex = Int(gesture.location(in: self).x / CGFloat(titleLength)) - 2
                        }
                        
                        print("tmpIndex = \(tmpIndex)")
                        
                        if tmpIndex <= titleLength && tmpIndex >= 0 {
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, tmpIndex))
                            titleLabel.attributedText = attributeString
                        }
                    }
                    else {
                        let titleLength = originalTitle!.characters.count
                        
                        var tmpIndex = 0
                        
                        if titleLength > 10 {
                            tmpIndex = Int(gesture.location(in: self).x * 5 / CGFloat(titleLength)) - 10
                        }
                        else {
                            tmpIndex = Int(gesture.location(in: self).x / CGFloat(titleLength)) - 2
                        }
                        
                        if tmpIndex <= titleLength && tmpIndex >= 0 {
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length - tmpIndex))
                            titleLabel.attributedText = attributeString
                        }
                    }
                }
            }
        }
        else if gesture.state == .ended {
            if isEditingMode {
                if isCrossedOut == false {
                    if gesture.velocity(in: self).x > 0 {
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                        titleLabel.attributedText = attributeString
                        isCrossedOut = true
                    }
                    else {
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, 0))
                        titleLabel.attributedText = attributeString
                        isCrossedOut = false
                    }
                }
                else {
                    if gesture.velocity(in: self).x <= 0 {
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                        titleLabel.attributedText = attributeString
                        isCrossedOut = true
                    }
                    else {
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, 0))
                        titleLabel.attributedText = attributeString
                        isCrossedOut = false
                    }
                }
            }
            
            isEditingMode = true
            isPanGestureStarted = false
            isMultiGestureAllowed = true
            isInTheMiddleOfCrossingOut = false
        }
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return isMultiGestureAllowed
    }
}


