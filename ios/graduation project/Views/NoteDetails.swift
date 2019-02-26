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
        if name.text == "" || content.text == "" {
            let alert = UIAlertController(title: "", message: "You Can't Leave Any Of These Two Fields Empty.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Discard", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }))
            
            present(alert, animated: true, completion: nil)
        
        }else{
            
            let note : UserNotes!
            
            if editOrDeleteNote == nil{
                note = UserNotes(context: context)
            }else{
                note = editOrDeleteNote
            }
            
            note.notename = name.text
            note.notecontent = content.text
            note.date = NSDate() as Date
            do{
                appdelegate.saveContext()
                name.text = ""
                content.text = ""
                print("saved")
            }catch{
                print("error",error.localizedDescription)
            }
            
            navigationController?.popViewController(animated: true)
    }
}
    
    @IBAction func cancel(_ sender: Any) {
        if name.text != "" || content.text != ""{
            if editOrDeleteNote == nil{
            let alert = UIAlertController(title: "", message: "Do You Want To Discard This Note ?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))

            alert.addAction(UIAlertAction(title: "Discard", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }))
            
            present(alert, animated: true, completion: nil)
            } else if editOrDeleteNote != nil {
                if name.text != editOrDeleteNote?.notename || content.text != editOrDeleteNote?.notecontent {
                    let alert = UIAlertController(title: "", message: "Do You Want To Discard The Change You Have Made? ", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    
                    alert.addAction(UIAlertAction(title: "Discard", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    }))
                    
                    present(alert, animated: true, completion: nil)
                }else{
                    navigationController?.popViewController(animated: true)
                }
                
            }
        }else{
            navigationController?.popViewController(animated: true)
        }

    }
    
    func loadForEdit(){
        if let selectedNote = editOrDeleteNote{
            name.text = selectedNote.notename
            content.text = selectedNote.notecontent
        }
    }
}
