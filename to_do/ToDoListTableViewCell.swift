//
//  ToDoListTableViewCell.swift
//  to_do
//
//  Created by chansung on 9/13/16.
//  Copyright © 2016 chansung_eunkyo. All rights reserved.
//

import UIKit

var starY: CGFloat?
var EndY: CGFloat?


class ToDoListTableViewCell: UITableViewCell {
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var tableView: UITableView?
    
    var isCrossedOut: Bool = false
    var isEditingMode: Bool  = false
    
    var originalTitle: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanned))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func didPanned(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Began {
            print("a = \(gesture.velocityInView(self).x)")
            
            starY = gesture.translationInView(self.tableView).y
            gesture
            if gesture.velocityInView(self).x < 0 {
                isEditingMode = true
            }
        }
        
        else if gesture.state == .Changed {
            EndY = gesture.translationInView(self.tableView).y
            print("start Y - end Y = " + String(abs(starY! - EndY!)) )
            
            if isEditingMode == false && isCrossedOut == false && (abs(starY! - EndY!) < 5 ){
                let titleLength = originalTitle!.characters.count
                let tmpIndex = Int(gesture.locationInView(self).x * 10 / CGFloat(titleLength)) - 10
                
                if tmpIndex < titleLength && tmpIndex >= 0 {
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, tmpIndex))
                    titleLabel.attributedText = attributeString
                }
            }
            else if isEditingMode == false && isCrossedOut == true && (abs(starY! - EndY!) < 5 ) {
                let titleLength = originalTitle!.characters.count
                let tmpIndex = Int(gesture.locationInView(self).x * 10 / CGFloat(titleLength)) - 10
                
                print("tmpIndex = \(gesture.locationInView(self).x), \(titleLength), \(tmpIndex)")
                
                if tmpIndex < titleLength && tmpIndex >= 0 {
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length - tmpIndex))
                    titleLabel.attributedText = attributeString
                }
            }
        }
        else if gesture.state == .Ended {
            EndY = gesture.translationInView(self.tableView).y
            print("start Y - end dddY = " + String(abs(starY! - EndY!)) )
            
            if isEditingMode == false && isCrossedOut == false && (abs(starY! - EndY!) < 5 ){
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                titleLabel.attributedText = attributeString
                isCrossedOut = true
            }
            else if isEditingMode == false && isCrossedOut == true && (abs(starY! - EndY!) < 5){
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, 0))
                titleLabel.attributedText = attributeString
                isCrossedOut = false
            }
        }
    }
    
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func didSwipeToRight(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizerDirection.Right {
            
            
           print("hey there, right swipe gesture? - \(gesture.locationInView(self))")
            if isCrossedOut {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                titleLabel.attributedText = attributeString
            }
            else {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                titleLabel.attributedText = attributeString
            }
        }
    }
}
