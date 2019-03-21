//
//  DoneTableCell.swift
//  graduation project
//
//  Created by farah on 3/2/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class DoneTableCell: UITableViewCell {

    @IBOutlet weak var doneCat: UILabel!
    @IBOutlet weak var doneTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func doneCell(item: DoneItems) {
        
        doneTitle.text = item.donetitle
        doneCat.text = item.fromdonetocategory?.categoryname
        doneCat.textColor = item.fromdonetocategory?.categorycolor as? UIColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
