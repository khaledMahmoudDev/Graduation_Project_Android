//
//  NoteDetails.swift
//  graduation project
//
//  Created by farah on 2/23/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData

class NoteDetails: UIViewController, UITextViewDelegate , UITextFieldDelegate {
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var name: UITextField!
    var editOrDeleteNote: UserNotes?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content.text = "Enter Note.."
        content.textColor = UIColor.lightGray
        content.returnKeyType = .done
        content.delegate = self
        
        name.text = "Enter Note Title"
        name.textColor = UIColor.lightGray
        name.returnKeyType = .done
        name.delegate = self
        
        if editOrDeleteNote != nil{
            loadForEdit()
        }
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Enter Note Title"{
            textField.text = ""
            textField.textColor = UIColor.black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            name.text = "Enter Note Title"
            name.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter Note.."{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            content.text = "Enter Note.."
            content.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func save(_ sender: Any) {
        if name.text == "" || content.text == "" || (name.text == "Enter Note Title" && name.textColor == UIColor.lightGray) || (content.text == "Enter Note.." && content.textColor == UIColor.lightGray){
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
            }
            
            navigationController?.popViewController(animated: true)
    }
}
    
    @IBAction func cancel(_ sender: Any) {
        if name.text != "" || content.text != "" || (name.text != "Enter Note Title" && name.textColor != UIColor.lightGray) || (content.text != "Enter Note.." && content.textColor != UIColor.lightGray) {
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
