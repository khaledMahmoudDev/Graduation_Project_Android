//
//  CategoryPopUp.swift
//  graduation project
//
//  Created by farah on 3/4/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData

class CategoryPopUp: UIViewController ,UITextFieldDelegate , UICollectionViewDataSource, UICollectionViewDelegate ,UIPickerViewDelegate , UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{

  
    @IBOutlet weak var newCategory: UITextField!
    
    
    @IBOutlet weak var pickerview: UIPickerView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableview: UITableView!
    
    var controller : NSFetchedResultsController<Categories>!
    
    
    var colorArray = [UIColor.red, UIColor.green, UIColor.blue, UIColor.cyan, UIColor.darkGray, UIColor.gray, UIColor.lightGray, UIColor.magenta, UIColor.orange, UIColor.purple, UIColor.yellow]
    
    var colorToPass : UIColor!
    var catFetchedForPopUp = [Categories]()
    
    
    //static variable to declare a variable is selected from picker view to handle deleting
    static var Selected = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadCatForPopUp()
        loadCategories()
        newCategory.delegate = self
        //hide the collection view of colors
        self.collectionView.isHidden = true
        //self.pickerview.isHidden = true
        
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(Done))
        self.navigationItem.rightBarButtonItem = doneButton
        
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
    
    
    @objc func Done(){

        let goBackToDetails = storyboard?.instantiateViewController(withIdentifier: "tododetails") as! ToDoDetails
        
        goBackToDetails.showData = newCategory.text!
        print(goBackToDetails.showData)
        goBackToDetails.showColor = colorToPass
        
        let newcat = Categories(context: context)
        newcat.categoryname = newCategory.text!
        newcat.categorycolor = colorToPass
        do{ appdelegate.saveContext()
            newCategory.text = ""
            print("saved")
            
        }catch{
            print(error.localizedDescription)
        }
        
       self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.pickerview.reloadAllComponents()
        }
        LoadCatForPopUp()
        self.tableview.reloadData()
    }
   
    
    //function to fetch objects from coredata
    func LoadCatForPopUp(){
        let fetchReq : NSFetchRequest<Categories> = Categories.fetchRequest()
        do {
            catFetchedForPopUp = try context.fetch(fetchReq)
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    //functions of picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return catFetchedForPopUp.count

    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category = catFetchedForPopUp[row]
//        newCategory.text = category.categoryname
//        newCategory.textColor = category.categorycolor as? UIColor
//
        //delet the selectd item, flag is set when delet buttion is clicked
//        if CategoryPopUp.Selected == 1 {
//            context.delete(category)
//            appdelegate.saveContext()
//            newCategory.text = ""
//            print("deleted from picker")
//            CategoryPopUp.Selected = 0
//            catFetchedForPopUp.remove(at: row)
//            pickerview.reloadAllComponents()
//
//        }
        
        return category.categoryname
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = catFetchedForPopUp[row]
      //  var editedText = ""
        newCategory.text = category.categoryname
        newCategory.textColor = category.categorycolor as? UIColor
        if CategoryPopUp.Selected == 1 {
            context.delete(category)
            appdelegate.saveContext()
            newCategory.text = ""
            print("deleted from picker at did select",row)
            CategoryPopUp.Selected = 0
            catFetchedForPopUp.remove(at: row)
            DispatchQueue.main.async {
                self.pickerview.reloadAllComponents()
            }
            
        }
        
       
    }

    //action of delet button to select item
    @IBAction func deleteFromPicker(_ sender: Any) {
        CategoryPopUp.Selected = 1
        DispatchQueue.main.async {
            self.pickerview.reloadAllComponents()
        }
        
    }
   //edit a text in picker,remove old and save to a new one
    @IBAction func EditInPicker(_ sender: Any) {

        CategoryPopUp.Selected = 1
        let newcat = Categories(context: context)
        newcat.categoryname = newCategory.text!
        newcat.categorycolor = colorToPass
        do{ appdelegate.saveContext()
            print("saved")
            
        }catch{
            print(error.localizedDescription)
        }
        catFetchedForPopUp.append(newcat)
        DispatchQueue.main.async {
            self.pickerview.reloadAllComponents()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        
        cell.backgroundColor = self.colorArray[indexPath.item]
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let SelectedItem = indexPath.row + 1
        print(SelectedItem)
        self.newCategory.textColor = self.colorArray[indexPath.item]
        self.colorToPass = self.colorArray[indexPath.item]
    }
    
    
    @IBAction func toggleCollectionViewHideShow(sender: UIButton) {
        if collectionView.isHidden == true{
            collectionView.isHidden = false
            pickerview.isHidden = true
        }else{
            collectionView.isHidden = true
            pickerview.isHidden = false
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destvc = segue.destination as! ToDoDetails
        destvc.showData = newCategory.text!
        destvc.showColor = colorToPass

        let newcat = Categories(context: context)
        newcat.categoryname = newCategory.text!
        newcat.categorycolor = colorToPass
        do{ appdelegate.saveContext()
            newCategory.text = ""
            print("saved")

        }catch{
            print(error.localizedDescription)
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        newCategory.resignFirstResponder()
        self.collectionView.isHidden = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.collectionView.isHidden = true
    }
    
    
    
    
    
    //-----------------------------------------------------------
    
    
    
    
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
        let cell = tableview.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CatTableCell
        configureCellForCategories(cell: cell, indexPath: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let obj = controller.fetchedObjects{
            let todo = obj[indexPath.row]
            print(indexPath.row)
            
            newCategory.text = todo.categoryname
            newCategory.textColor = todo.categorycolor as? UIColor

        }
    }
    

    @IBAction func editCatTableRow(_ sender: Any) {
        
        var path = tableview.indexPathForSelectedRow
        
        let obj = self.controller.fetchedObjects
        let Cat = obj![(path?.row)!]
        
        if Cat.categoryname != self.newCategory.text || Cat.categorycolor != self.newCategory.textColor{
            Cat.categoryname = self.newCategory.text
            Cat.categorycolor = self.newCategory.textColor
            appdelegate.saveContext()
            print("cat is edited")
        }
        
        
    }
    
    
    @IBAction func deleteCatTableRow(_ sender: Any) {
        
        var path = tableview.indexPathForSelectedRow
        
        let obj = self.controller.fetchedObjects
        let Cat = obj![(path?.row)!]
        
        context.delete(Cat)
        appdelegate.saveContext()
        print("cat is deleted")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.endUpdates()
    }
    
    func configureCellForCategories(cell: CatTableCell, indexPath: IndexPath){
        let itemChosen = controller.object(at: indexPath)
        cell.categoryCell(item: itemChosen)
        
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath{
                tableview.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath{
                tableview.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath{
                let cell = tableview.cellForRow(at: indexPath) as! CatTableCell
                configureCellForCategories(cell: cell, indexPath: indexPath )
            }
            break
        case .move:
            if let indexPath = indexPath{
                tableview.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                tableview.insertRows(at: [indexPath], with: .fade)
            }
            break
        @unknown default:
            break
        }
        
        
    }
    
    
}

