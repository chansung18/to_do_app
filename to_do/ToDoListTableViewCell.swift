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

protocol ToDoListTableViewCellDelegate{
    func cellValueChanged(_ cell: ToDoListTableViewCell);
}

class ToDoListTableViewCell: UITableViewCell {
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var index: Int = 0
    var delegate : ToDoListTableViewCellDelegate?
    
    var directionOfRight: Bool = false
    var tableView: UITableView?
    
    var isEditingMode: Bool  = false
    
    var isCrossedOut: Bool = false {
        didSet {
            delegate?.cellValueChanged(self)
        }
    }
    
    var originalTitle: String? {
        didSet {
            titleLabel.text = originalTitle
            delegate?.cellValueChanged(self)
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
//            print("a = \(gesture.velocityInView(self).x)")
            
            starY = gesture.translation(in: self.tableView).y
            if gesture.velocity(in: self).x < 0 {
                isEditingMode = true
            }
            else if gesture.velocity(in: self).x > 0 {
                directionOfRight = true
            }
        }
        
        else if gesture.state == .changed {
            EndY = gesture.translation(in: self.tableView).y
//            print("start Y - end Y = " + String(abs(starY! - EndY!)) )
            
            if isEditingMode == false && isCrossedOut == false && abs(starY! - EndY!) < 10 && directionOfRight == true {
                let titleLength = originalTitle!.characters.count
                let tmpIndex = Int(gesture.location(in: self).x * 10 / CGFloat(titleLength)) - 10
                
                if tmpIndex < titleLength && tmpIndex >= 0 {
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, tmpIndex))
                    titleLabel.attributedText = attributeString
                }
            }
            else if isEditingMode == false && isCrossedOut == true && (abs(starY! - EndY!) < 10 ) && directionOfRight == true {
                let titleLength = originalTitle!.characters.count
                let tmpIndex = Int(gesture.location(in: self).x * 10 / CGFloat(titleLength)) - 10
                
//                print("tmpIndex = \(gesture.locationInView(self).x), \(titleLength), \(tmpIndex)")
                
                if tmpIndex < titleLength && tmpIndex >= 0 {
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length - tmpIndex))
                    titleLabel.attributedText = attributeString
                }
            }
        }
        else if gesture.state == .ended {
            EndY = gesture.translation(in: self.tableView).y
//            print("start Y - end dddY = " + String(abs(starY! - EndY!)) )
            
            if isEditingMode == false && isCrossedOut == false && (abs(starY! - EndY!) < 10 && directionOfRight == true){
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                titleLabel.attributedText = attributeString
                isCrossedOut = true
            }
            else if isEditingMode == false && isCrossedOut == true && (abs(starY! - EndY!) < 10) && directionOfRight == true{
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleLabel.text!)
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, 0))
                titleLabel.attributedText = attributeString
                isCrossedOut = false
            }
        }
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func didSwipeToRight(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            
            
           print("hey there, right swipe gesture? - \(gesture.location(in: self))")
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
