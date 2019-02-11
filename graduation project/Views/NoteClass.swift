//
//  NoteClass.swift
//  graduation project
//
//  Created by farah on 2/7/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class NoteClass: NSObject {
    
    static var noteArray : Array<String> = []
    
   class func addNotes (note:String){
        NoteClass.noteArray.append(note)
    }
    
   class func removeNote (atIndex:Int){
        NoteClass.noteArray.remove(at: atIndex)
    }

}
