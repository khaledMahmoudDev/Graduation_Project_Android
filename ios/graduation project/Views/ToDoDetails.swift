//
//  ToDoDetails.swift
//  graduation project
//
//  Created by farah on 2/5/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData

class ToDoDetails: UIViewController ,  UIPopoverPresentationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var todoPicker: UIPickerView!
    @IBOutlet weak var todoDetails: UITextView!
    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var saveToDone: UIButton!
    var showData = ""
    var showColor : UIColor!
    var catFetched = [Categories]()
    var editORdeletTODO:ToDoItems?
    var editOrEditDone:DoneItems?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        
        
        todoPicker.delegate = self
        todoPicker.dataSource = self
        LoadCat()
        saveToDone.isHidden = true
        
        
        
        if editORdeletTODO != nil{
            loadforEditTODO()
            saveToDone.isHidden = false
        }
        
        if editOrEditDone != nil{
            loadforEditDone()
        }
        
    }
    
    
    func LoadCat(){
        let fetchReq : NSFetchRequest<Categories> = Categories.fetchRequest()
        do {
            catFetched = try context.fetch(fetchReq)
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catFetched.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category = catFetched[row]
        showLabel.text = category.categoryname
        return category.categoryname
        
    }
    
    func loadforEditTODO (){
        if let editedItem = editORdeletTODO{
            todoTitle.text = editedItem.todotitle
            todoDetails.text = editedItem.tododetails
        
            if let editedCat = editedItem.tocategory{
                var index = 0
                while index<catFetched.count {
                    let row = catFetched[index]
                    if row.categoryname == editedCat.categoryname {
                        todoPicker.selectRow(index, inComponent: 0, animated: false)
                    }
                    index = index + 1
                    
                }
            }
        }
       
    }
    
    func loadforEditDone (){
        if let doneItem = editOrEditDone{
            todoTitle.text = doneItem.donetitle
            todoDetails.text = doneItem.donedetails
            
            if let doneCat = doneItem.fromdonetocategory{
                var index = 0
                while index<catFetched.count {
                    let row = catFetched[index]
                    if row.categoryname == doneCat.categoryname {
                        todoPicker.selectRow(index, inComponent: 0, animated: false)
                    }
                    index = index + 1
                    
                }
            }
        }
        
    }
    
    @IBAction func popupbtn(_ sender: Any) {
        self.performSegue(withIdentifier: "pop" , sender : self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pop" {
            let vc = segue.destination
            vc.preferredContentSize = CGSize(width: 400, height: 400)
            let controller = vc.popoverPresentationController
            
            controller?.delegate = self
            //you could set the following in your storyboard
            controller?.sourceView = self.view
            controller?.sourceRect = CGRect(x: 0, y: 0, width: 100, height: 100)
            controller?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 1)
            
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //return .fullScreen
        //return .popover
        //return .pageSheet
        return .none
        //return .overFullScreen
        
    }
    
    @IBAction func unwindSegue (_sender : UIStoryboardSegue){
        showLabel.text = showData
        showLabel.textColor = showColor
        
    }
    
 
    @objc func save(){
        let newItem:ToDoItems!
        if editORdeletTODO == nil{
            newItem = ToDoItems (context: context)
        }
        else{
            newItem = editORdeletTODO
        }
        
        newItem.todotitle = todoTitle.text!
        newItem.tododetails = todoDetails.text!
        newItem.tododate = NSDate() as Date
        newItem.tocategory = catFetched[todoPicker.selectedRow(inComponent: 0)]
        do {
            appdelegate.saveContext()
            todoDetails.text = ""
            todoTitle.text = ""
            print("saved")
        } catch  {
            print(error.localizedDescription)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
   
    
    @IBAction func moveToDone(_ sender: Any) {
        let doneItem : DoneItems!
        if editOrEditDone == nil && editORdeletTODO != nil{
            doneItem = DoneItems (context: context)
            doneItem.donetitle = todoTitle.text!
            doneItem.donedetails = todoDetails.text!
            doneItem.donedate = NSDate() as Date
            doneItem.fromdonetocategory = catFetched[todoPicker.selectedRow(inComponent: 0)]
            do {
                appdelegate.saveContext()
                todoDetails.text = ""
                todoTitle.text = ""
                print("saved to done")
            } catch  {
                print(error.localizedDescription)
            }
            
            context.delete(editORdeletTODO!)
            appdelegate.saveContext()
            print("deleted from todo")
            
            self.performSegue(withIdentifier: "doneList" , sender : self)
        }
    }
}
