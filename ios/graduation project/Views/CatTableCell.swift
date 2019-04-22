//
//  CatTableCell.swift
//  graduation project
//
//  Created by ahmed on 4/22/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class CatTableCell: UITableViewCell {

    @IBOutlet weak var catLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func categoryCell(item: Categories) {
        
        catLabel.text = item.categoryname
        catLabel.textColor = item.categorycolor as? UIColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
