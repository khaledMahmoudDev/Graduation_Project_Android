//
//  NoteDetails.swift
//  graduation project
//
//  Created by farah on 2/23/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class NoteDetails: UIViewController, UITextViewDelegate , UITextFieldDelegate {
    
    var ref: DatabaseReference!
    var choosedNote : String!
    var noteNameFIR : String!
    var noteContentFIR : String!
    //var DetailsArray = [Note]()
    
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var name: UITextField!
    //var editOrDeleteNote: UserNotes?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if choosedNote != nil {
            fetchUsersNoteFromFirebase()
            content.textColor = UIColor.black
            content.returnKeyType = .done
            content.delegate = self
            name.textColor = UIColor.black
            name.returnKeyType = .done
            name.delegate = self
        }else{
            content.text = "Enter Note.."
            content.textColor = UIColor.lightGray
            content.returnKeyType = .done
            content.delegate = self
            name.text = "Enter Note Title"
            name.textColor = UIColor.lightGray
            name.returnKeyType = .done
            name.delegate = self
            
        }
        }
        
//        if let unwarppedNoteDetails = choosedNote{
//            print("here we are el7 :'D",unwarppedNoteDetails)
//        }
        
        
        
//        if content.text != "" && name.text != ""{
//            print("hereeeeeee")
//            content.textColor = UIColor.black
//            content.returnKeyType = .done
//            content.delegate = self
//            name.textColor = UIColor.black
//            name.returnKeyType = .done
//            name.delegate = self
//
//        }else{
//
//
//            content.text = "Enter Note.."
//            content.textColor = UIColor.lightGray
//            content.returnKeyType = .done
//            content.delegate = self
//            name.text = "Enter Note Title"
//            name.textColor = UIColor.lightGray
//            name.returnKeyType = .done
//            name.delegate = self
//        }
        
        
        
        
//        if editOrDeleteNote != nil{
//            loadForEdit()
//        }
    //}
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if name.text == "Enter Note Title"{
            name.text = ""
            name.textColor = UIColor.black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if name.text == "" {
            name.text = "Enter Note Title"
            name.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if content.text == "Enter Note.."{
            content.text = ""
            content.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if content.text == "" {
            content.text = "Enter Note.."
            content.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            content.resignFirstResponder()
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
            
//            let note : UserNotes!
//
//            if editOrDeleteNote == nil{
//                note = UserNotes(context: context)
//            }else{
//                note = editOrDeleteNote
//            }
//
//            note.notename = name.text
//            note.notecontent = content.text
//            note.date = NSDate() as Date
//            do{
//                appdelegate.saveContext()
//                name.text = ""
//                content.text = ""
//                print("saved")
//            }
            
            if choosedNote != nil{
                updateUsersNoteInFirebase()
            }else{
                saveUsersNoteInFirebase()
            }
            navigationController?.popViewController(animated: true)
    }
}
    
    @IBAction func cancel(_ sender: Any) {
        if name.text != "" || content.text != "" /*|| (name.text != "Enter Note Title" && name.textColor != UIColor.lightGray) || (content.text != "Enter Note.." && content.textColor != UIColor.lightGray) */{
            if choosedNote == nil && ((name.text != "Enter Note Title" && name.textColor != UIColor.lightGray) || (content.text != "Enter Note.." && content.textColor != UIColor.lightGray)){
                let alert = UIAlertController(title: "", message: "Do You Want To Discard This Note ?", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))

                alert.addAction(UIAlertAction(title: "Discard", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }))

                present(alert, animated: true, completion: nil)
            }else if choosedNote != nil && (name.text != noteNameFIR || content.text != noteContentFIR ) {
                
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



//            if editOrDeleteNote == nil{
//            let alert = UIAlertController(title: "", message: "Do You Want To Discard This Note ?", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//
//            alert.addAction(UIAlertAction(title: "Discard", style: .default, handler: { (action) in
//                alert.dismiss(animated: true, completion: nil)
//                self.navigationController?.popViewController(animated: true)
//            }))
//
//            present(alert, animated: true, completion: nil)
//            } else if editOrDeleteNote != nil {
//                if name.text != editOrDeleteNote?.notename || content.text != editOrDeleteNote?.notecontent {
//                    let alert = UIAlertController(title: "", message: "Do You Want To Discard The Change You Have Made? ", preferredStyle: .alert)
//
//                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
//                        alert.dismiss(animated: true, completion: nil)
//                    }))
//
//
//                    alert.addAction(UIAlertAction(title: "Discard", style: .default, handler: { (action) in
//                        alert.dismiss(animated: true, completion: nil)
//                        self.navigationController?.popViewController(animated: true)
//                    }))
//
//                    present(alert, animated: true, completion: nil)
//                }else{
//                    navigationController?.popViewController(animated: true)
//                }
//
//            }
//        }else{
//            navigationController?.popViewController(animated: true)
//        }

        }
    }
    
//    func loadForEdit(){
//        if let selectedNote = editOrDeleteNote{
//            name.text = selectedNote.notename
//            content.text = selectedNote.notecontent
//        }
//    }
    
    
  
    
    private var User : User? {
        return Auth.auth().currentUser
    }
  
    func saveUsersNoteInFirebase(){
        
        guard let noteContent = content.text, let noteName = name.text else{
            return
        }
        self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
        let values = ["noteName" : noteName , "noteContent": noteContent]
        self.ref.child("UserNotes").child(User!.uid).childByAutoId().setValue(values)
        
            print("saved savely for the current user")
    }
    
    
    func fetchUsersNoteFromFirebase(){
        
      
        let userId = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("UserNotes").child(userId!).child(choosedNote)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.noteNameFIR = value?["noteName"] as? String ?? ""
            self.name.text = self.noteNameFIR
            self.noteContentFIR = value?["noteContent"] as? String ?? ""
            self.content.text = self.noteContentFIR
        

            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateUsersNoteInFirebase(){
        
        let userId = User!.uid
        
        guard let noteContent = content.text, let noteName = name.text else{
            return
        }
        
        ref = Database.database().reference().child("UserNotes").child(userId).child(choosedNote)
        let userNote = ["noteName" : noteName , "noteContent": noteContent]
        ref.updateChildValues(userNote)

        
    }
    
}



