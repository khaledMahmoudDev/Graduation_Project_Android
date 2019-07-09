//
//  DoneTableCell.swift
//  graduation project
//
//  Created by farah on 7/9/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class DoneTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timeAndDate: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
