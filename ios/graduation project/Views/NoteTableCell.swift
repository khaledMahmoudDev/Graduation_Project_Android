//
//  NoteTableCell.swift
//  graduation project
//
//  Created by farah on 2/14/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class NoteTableCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func mycell(note: UserNotes){
        name.text = note.notename
                let dateformat = DateFormatter()
                dateformat.dateFormat = "dd/MM/yyyy h:mm a"
                date.text = dateformat.string(from: note.date as! Date)
        
    }

}
