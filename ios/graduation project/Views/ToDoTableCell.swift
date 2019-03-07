//
//  ToDoTableCell.swift
//  graduation project
//
//  Created by farah on 3/2/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableCell: UITableViewCell {

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemCat: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func todoCell(item: ToDoItems) {
        
        itemTitle.text = item.todotitle
        itemCat.text = item.tocategory?.categoryname
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
