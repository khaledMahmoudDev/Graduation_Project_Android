//
//  updateNoteDetails.swift
//  graduation project
//
//  Created by farah on 2/16/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData


    var getrecord = NSManagedObject()

class updateNoteDetails: UIViewController {

    @IBOutlet weak var updateTitle: UITextField!
    @IBOutlet weak var updateContent: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        updateTitle.text = getrecord.value(forKey: "title") as? String
        updateContent.text = getrecord.value(forKey: "content") as? String

    }
    

    @objc func save(){
        let backToNote = storyboard?.instantiateViewController(withIdentifier: "note")
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let entitidec = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let result = try managedContext.fetch(request)
            if result.count > 0 {
                let manage = result[0] as! NSManagedObject
                manage.setValue(updateTitle.text!, forKey: "title")
                manage.setValue(updateContent.text!, forKey: "content")
                
                try managedContext.save()
                //self.navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
                
            }
            else{
                print("Record Not Found")
            }
        } catch  {}
    }
    
    @objc func cancel(){
        let backToNote = storyboard?.instantiateViewController(withIdentifier: "note")

        if updateTitle.text != "" || updateContent.text != ""{
            
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
    


}
