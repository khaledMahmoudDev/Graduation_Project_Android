//
//  NoteTableCell.swift
//  graduation project
//
//  Created by farah on 2/14/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class NoteTableCell: UITableViewCell {
    
    
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteContent: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
