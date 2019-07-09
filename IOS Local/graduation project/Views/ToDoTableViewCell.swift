//
//  ToDoTableViewCell.swift
//  graduation project
//
//  Created by ahmed on 7/9/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    var PriorityLabelColor = priorityColor
//    
//    switch (priosityColor){
//    
//    case red:
//            label.backgroundcolor = uicolor.red
//    
//    case yellow:
//            label.backgroundcolor = uicolor.yellow
//
//    case green:
//            label.backgroundcolor = uicolor.green
//
//    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
