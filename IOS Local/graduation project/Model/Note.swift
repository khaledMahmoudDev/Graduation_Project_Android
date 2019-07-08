//
//  Note.swift
//  graduation project
//
//  Created by ahmed on 5/13/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import Foundation
class Note{
    var noteName : String
    var noteKey : String
    var noteDate : String
    var noteTime : String
    
    init (noteNametxt : String, noteKeytxt : String, noteDateTxt : String, noteTimeTxt : String) {
        noteName = noteNametxt
        noteKey = noteKeytxt
        noteDate = noteDateTxt
        noteTime = noteTimeTxt
    }
}
