//
//  MainEntryTableCell.swift
//  graduation project
//
//  Created by farah on 2/25/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class MainEntryTableCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
