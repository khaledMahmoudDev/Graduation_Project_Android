//
//  RedunTableCell.swift
//  graduation project
//
//  Created by ahmed on 4/25/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class RedunTableCell: UITableViewCell {

    @IBOutlet weak var redunCategoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    func categoryCell(item: Categories) {
        
        redunCategoryLabel.text = item.categoryname
        redunCategoryLabel.textColor = item.categorycolor as? UIColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
