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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
