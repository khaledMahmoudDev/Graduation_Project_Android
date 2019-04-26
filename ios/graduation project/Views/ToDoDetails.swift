//
//  ToDoDetails.swift
//  graduation project
//
//  Created by farah on 2/5/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData

class ToDoDetails: UIViewController ,  UIPopoverPresentationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate, selectCategoryProtocal, NSFetchedResultsControllerDelegate,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var todoPicker: UIPickerView!
    @IBOutlet weak var todoDetails: UITextView!
    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var saveToDone: UIButton!
    var showData : String = ""
    var showColor : UIColor!
    var IndexPathFromcat : Int?
    var catFetched = [Categories]()
    var editORdeletTODO:ToDoItems?
    var editOrEditDone:DoneItems?
    var controller : NSFetchedResultsController<Categories>!

    
    @IBOutlet weak var redunTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        showLabel.text = showData
//        showLabel.textColor = showColor
//        print(showData)
//        print(showLabel.text)
//
        showLabel.text = "Choose Category.."
        showLabel.textColor = UIColor.lightGray
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        todoDetails.text = "Enter Details.."
        todoDetails.textColor = UIColor.lightGray
        todoDetails.returnKeyType = .done
        todoDetails.delegate = self
        
        todoTitle.text = "Enter Title"
        todoTitle.textColor = UIColor.lightGray
        todoTitle.returnKeyType = .done
        todoTitle.delegate = self
        
        
        
        todoPicker.delegate = self
        todoPicker.dataSource = self
        todoPicker.isHidden = true
        LoadCat()
        saveToDone.isHidden = true
        
        
        
        if editORdeletTODO != nil{
            loadforEditTODO()
            saveToDone.isHidden = false
        }
        
        if editOrEditDone != nil{
            loadforEditDone()
        }
        
    
        loadCategories()
    }
    
    
    
    func loadCategories(){
        let fetchrequest:NSFetchRequest<Categories>=Categories.fetchRequest()
        
        let itemName = NSSortDescriptor (key: "categoryname", ascending: false)
        fetchrequest.sortDescriptors = [itemName]
        controller=NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
        
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        redunTable.reloadData()
        LoadCat()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//        showLabel.text = category.categoryname
//        showLabel.textColor = category.categorycolor as? UIColor
        return category.categoryname
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = catFetched[row]
        showLabel.text = category.categoryname
        showLabel.textColor = category.categorycolor as? UIColor
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
                      //  todoPicker.selectRow(index, inComponent: 0, animated: false)
                        //self.catFetched[IndexPathFromcat!]
                    
                    }
                    index = index + 1
                    
                }
            }
        }
        
    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "pop"){
            let categoryView = segue.destination as! CategoryView
            categoryView.selectionDelegete = self
        }
    }
    
    
    func selectCategory(catName: String, catColor: UIColor, indexPath: Int) {
        showLabel.text = catName
        showLabel.textColor = catColor
        IndexPathFromcat = indexPath
        //print(IndexPathFromcat)
    }
    

    @IBAction func showAndHidePicker(_ sender: Any) {
        if todoPicker.isHidden == true{
            todoPicker.isHidden = false
        }else{
            todoPicker.isHidden = true
        }
    }
    
 
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.todoPicker.isHidden = true
        if textField.text == "Enter Title"{
            textField.text = ""
            textField.textColor = UIColor.black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            todoTitle.text = "Enter Title"
            todoTitle.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.todoPicker.isHidden = true
        if textView.text == "Enter Details.."{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            todoDetails.text = "Enter Details.."
            todoDetails.textColor = UIColor.lightGray
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    
    
    @objc func save(){
        if todoTitle.text == "" || todoDetails.text == "" || (todoTitle.text == "Enter Title" && todoTitle.textColor == UIColor.lightGray) || (todoDetails.text == "Enter Details.." && todoDetails.textColor == UIColor.lightGray){
            let alert = UIAlertController(title: "", message: "You Can't Leave Any Of These Three Fields Empty.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Discard", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }))
            
            present(alert, animated: true, completion: nil)
            
        }else if editOrEditDone != nil && editORdeletTODO == nil{
            let alert = UIAlertController(title: "", message: "Do you want to add this to new ToDo?", preferredStyle: .alert)
            
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                let newItem: ToDoItems!
                newItem = ToDoItems (context: context)
                newItem.todotitle = self.todoTitle.text!
                newItem.tododetails = self.todoDetails.text!
                newItem.tododate = NSDate() as Date
                newItem.tocategory = self.catFetched[self.IndexPathFromcat!]
                print("need to be printed",self.IndexPathFromcat!)
                //newItem.tocategory = self.showLabel.text!
                
                do {
                    appdelegate.saveContext()
                    self.todoDetails.text = ""
                    self.todoTitle.text = ""
                    print("new saved to todo")
                }
                
                context.delete(self.editOrEditDone!)
                appdelegate.saveContext()
                print("deleted from done")
                self.navigationController?.popViewController(animated: false)
            }))
            
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
            
        }else{
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
        //newItem.tocategory = catFetched[redunTable.indexPath(for: RedunTableCell)!]
        do {
            appdelegate.saveContext()
            todoDetails.text = ""
            todoTitle.text = ""
            print("saved")
        }
        navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func cancel(){
        if todoTitle.text != "" || todoDetails.text != "" /*|| (todoTitle.text != "Enter Title" && todoTitle.textColor != UIColor.lightGray) || (todoDetails.text != "Enter Details.." && todoDetails.textColor != UIColor.lightGray)*/ {
            if editORdeletTODO == nil && editOrEditDone == nil{
                let alert = UIAlertController(title: "", message: "Do You Want To Discard This TODO ?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                alert.addAction(UIAlertAction(title: "Discard", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
                
                present(alert, animated: true, completion: nil)
            } else if editORdeletTODO != nil {
                if todoTitle.text != editORdeletTODO?.todotitle || todoDetails.text != editORdeletTODO?.tododetails {
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
                
            }else if editOrEditDone != nil{
                if todoTitle.text != editOrEditDone?.donetitle || todoDetails.text != editOrEditDone?.donedetails{
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
    
   
    
    @IBAction func moveToDone(_ sender: Any) {
        let doneItem : DoneItems!
        if editOrEditDone == nil && editORdeletTODO != nil{
            doneItem = DoneItems (context: context)
            doneItem.donetitle = todoTitle.text!
            doneItem.donedetails = todoDetails.text!
            doneItem.donedate = NSDate() as Date
            doneItem.fromdonetocategory = catFetched[IndexPathFromcat!]
            do {
                appdelegate.saveContext()
                todoDetails.text = ""
                todoTitle.text = ""
                print("saved to done")
            }
            
            context.delete(editORdeletTODO!)
            appdelegate.saveContext()
            print("deleted from todo")
            self.navigationController?.popViewController(animated: false)
            //self.performSegue(withIdentifier: "doneList" , sender : self)
        }
    }
    
   // ----------------
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = redunTable.dequeueReusableCell(withIdentifier: "redunTableCell", for: indexPath) as! RedunTableCell
        //cell.selectionStyle = UITableViewCell.SelectionStyle.default
        configureCellForCategories(cell: cell, indexPath: indexPath)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
    }
    
   
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        redunTable.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        redunTable.endUpdates()
    }
    
    func configureCellForCategories(cell: RedunTableCell, indexPath: IndexPath){
        let itemChosen = controller.object(at: indexPath)
        cell.categoryCell(item: itemChosen)
        
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath{
                redunTable.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath{
                redunTable.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath{
                let cell = redunTable.cellForRow(at: indexPath) as! RedunTableCell
                configureCellForCategories(cell: cell, indexPath: indexPath )
            }
            break
        case .move:
            if let indexPath = indexPath{
                redunTable.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                redunTable.insertRows(at: [indexPath], with: .fade)
            }
            break
        @unknown default:
            break
        }
        
        
    }
    
    
}



