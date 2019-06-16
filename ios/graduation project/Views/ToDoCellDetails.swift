//
//  ToDoCellDetails.swift
//  graduation project
//
//  Created by ahmed on 6/14/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit



class ToDoCellDetails: UIViewController {

    @IBOutlet weak var ToDoTitle: UITextField!
    @IBOutlet weak var ToDoDetail: UITextView!
    @IBOutlet weak var ToDoCategory: UITextField!
    
    
    
    //save button to save a todo in the table view
    
    @IBAction func saveTodo(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Save(_ sender: Any) {
        if (ToDoTitle.text != "" && ToDoDetail.text != "" && ToDoCategory.text != ""){
            
            var title = ToDoTitle.text
            var details = ToDoDetail.text
            var cat = ToDoCategory.text
            
            list.append(ToDoTitle.text!)
            ToDoTitle.text = ""
            ToDoDetail.text = ""
            ToDoCategory.text = ""
            
            
            //save the category in category label in todo table
            
        }
        else {
            let alert = UIAlertController(title: "", message: "Please,fill in all the fields.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
      
    }
    @IBAction func MoveToDone(_ sender: Any) {
        
        DoneList.append(ToDoTitle.text!)
        

    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        ToDoCategory.addTarget(self, action: showCats, for: UITouch)
//        func showCats (textfield: UITextField)
//        { // show the cats table}
//            
            
        // Do any additional setup after loading the view.
    }
    

    

}
