//
//  CategoryTableCell.swift
//  graduation project
//
//  Created by ahmed on 4/16/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func categoryCell(item: Categories) {
        
        categoryLabel.text = item.categoryname
        categoryLabel.textColor = item.categorycolor as? UIColor
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
