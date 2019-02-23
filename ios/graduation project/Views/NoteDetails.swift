//
//  NoteDetails.swift
//  graduation project
//
//  Created by farah on 2/23/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData

class NoteDetails: UIViewController {
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var name: UITextField!
    var editOrDeleteNote: UserNotes?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editOrDeleteNote != nil{
            loadForEdit()
        }
    }
    
    @IBAction func save(_ sender: Any) {
        let note : UserNotes!
        
        if editOrDeleteNote == nil{
            note = UserNotes(context: context)
        }else{
            note = editOrDeleteNote
        }
        
        note.notename = name.text
        note.notecontent = content.text
        note.date = Date()
        do{
            appdelegate.saveContext()
            name.text = ""
            content.text = ""
            print("saved")
        }catch{
            print("error",error.localizedDescription)
        }
        
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func loadForEdit(){
        if let selectedNote = editOrDeleteNote{
            name.text = selectedNote.notename
            content.text = selectedNote.notecontent
        }
    }
}
