//
//  ToDoCellDetails.swift
//  graduation project
//
//  Created by ahmed on 6/14/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import SwiftyMenu




class ToDoCellDetails: UIViewController , UITextViewDelegate {
    
    
    
    var categChoosen = "None"
    

    @IBOutlet weak var ToDoTitle: UITextField!
    @IBOutlet weak var ToDoDetail: UITextView!
    @IBOutlet weak var ToDoCategory: UITextField!
    
    
//    @IBOutlet weak var CategorySwiftyMenu: SwiftyMenu!
    
    
    @IBAction func ShoppingCat(_ sender: Any) {
        categChoosen = "Shopping"
        ToDoCategory.text = categChoosen
    }
    
    @IBAction func WorkCat(_ sender: Any) {
        categChoosen = "Work"
        ToDoCategory.text = categChoosen

    }
    @IBAction func FunCat(_ sender: Any) {
        categChoosen = "Fun"
        ToDoCategory.text = categChoosen

    }
    @IBAction func NoneCat(_ sender: Any) {
        categChoosen = "None"
        ToDoCategory.text = categChoosen

    }
    
//    private let optionsData = ["Work", "Shopping", "Fun", "Others"]
    

    
//
    //save button to save a todo in the table view
    
    @IBAction func saveTodo(_ sender: Any) {
        print("save clicked")
        
        if (ToDoTitle.text != "" && ToDoDetail.text != "" ){
            
            var title = ToDoTitle.text
            var details = ToDoDetail.text
            var cat = ToDoCategory.text
            
            list.append(ToDoTitle.text!)
            ToDoTitle.text = ""
            ToDoDetail.text = ""
            ToDoCategory.text = ""
            
            navigationController?.popViewController(animated: true)

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
       // list.remove(at: index(ofAccessibilityElement: self))
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        ToDoCategory.addTarget(self, action: showCats, for: UITouch)
//        func showCats (textfield: UITextField)
//        { // show the cats table}
        
        ToDoDetail.delegate = self
      //  CategorySwiftyMenu.delegate = self
        
//        CategorySwiftyMenu.delegate = self as? SwiftyMenuDelegate
//        CategorySwiftyMenu.options = optionsData as! [SwiftMenuDisplayable]
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        ToDoDetail.text = ""
        
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if (ToDoDetail.text == "") 
        {
            ToDoDetail.text = "Details"
        }
    }
    

}

//extension ViewController: SwiftyMenuDelegate {
//    func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
//        print("Selected option: \(selectedOption), at index: \(index)")
//        //save the selected option in a variable to handle
//        var category = selectedOption
//    }
//
//
//
//    // SwiftyMenu drop down menu will appear
//    func swiftyMenuWillAppear(_ swiftyMenu: SwiftyMenu) {
//        print("SwiftyMenu will appear.")
//    }
//
//    // SwiftyMenu drop down menu did appear
//    func swiftyMenuDidAppear(_ swiftyMenu: SwiftyMenu) {
//        print("SwiftyMenu did appear.")
//    }
//
//    // SwiftyMenu drop down menu will disappear
//    func swiftyMenuWillDisappear(_ swiftyMenu: SwiftyMenu) {
//        print("SwiftyMenu will disappear.")
//    }
//
//    // SwiftyMenu drop down menu did disappear
//    func swiftyMenuDidDisappear(_ swiftyMenu: SwiftyMenu) {
//        print("SwiftyMenu did disappear.")
//    }
//}
