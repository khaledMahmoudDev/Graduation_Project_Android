//
//  NoteDetails.swift
//  graduation project
//
//  Created by farah on 2/6/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData

class NoteDetails: UIViewController {

    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveButton

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func save(){
        //let backToNote = storyboard?.instantiateViewController(withIdentifier: "note")
        
        if name.text == "" || content.text == ""{
            let alert = UIAlertController(title: "Ooops", message: "you have miss one field or more ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: .default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert,animated: true, completion: nil)
            
        }else{
        saveNote{(done) in
            if done{
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                print("back")
            }else{
                print("stay here")
                }
            
            }
        }
    }
    
    @objc func cancel(){
        //let backToNote = storyboard?.instantiateViewController(withIdentifier: "note")
        //createAlert()
        if name.text != "" || content.text != ""{
            
            let alert = UIAlertController(title: "Discard This Note", message: "do you want to discard this not ? ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Discard", style: .default, handler: {(action) in
                self.navigationController?.popViewController(animated: true)
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title:"Cancel", style: .default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        }else{
                self.navigationController?.popViewController(animated: true)
        }
  
    }
    
    

    
    func saveNote(completion: (_ finished : Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let noteName = Note(context: managedContext)
        let noteContent = Note(context: managedContext)
        
        noteName.title = name.text
        noteContent.content = content.text
        
        do{
            try managedContext.save()
            print("saved")
            completion(true)
        }catch{
            print("not saved", error.localizedDescription)
            completion(false)
        }
    }



}
