//
//  CategoryView.swift
//  graduation project
//
//  Created by ahmed on 4/16/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData

protocol selectCategoryProtocal {
    func selectCategory (catName: String, catColor: UIColor, indexPath: Int)
}

class CategoryView: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var tableview: UITableView!
    var controller : NSFetchedResultsController<Categories>!
    
    var selectionDelegete: selectCategoryProtocal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cancelButton

        loadCategories()
    }
    
    
    @objc func add(){
        self.performSegue(withIdentifier: "goFromCatToCatEditOrDelete" , sender : self)

    }
    @objc func cancel(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableview.reloadData()
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
        let cell = tableview.dequeueReusableCell(withIdentifier: "catCell", for: indexPath) as! CategoryTableCell
        configureCellForCategories(cell: cell, indexPath: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let obj = controller.fetchedObjects{
            let todo = obj[indexPath.row]
            print(indexPath.row)
            
            selectionDelegete.selectCategory(catName: todo.categoryname!, catColor: (todo.categorycolor as? UIColor)!, indexPath: indexPath.row)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete"){(action,indexPath) in
            let obj = self.controller.fetchedObjects
            let Cat = obj![indexPath.row]
            context.delete(Cat)
            appdelegate.saveContext()
            print("deleted")
        }
    
        let editAction = UITableViewRowAction(style: .destructive, title: "edit") { (action, indexPath) in
            let obj = self.controller.fetchedObjects
            let Cat = obj![indexPath.row]
            let alert = UIAlertController(title: "Edit Category", message: "Please enter the new title for this category.", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = ""
            }
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                if Cat.categoryname != textField?.text{
                    Cat.categoryname = textField?.text
                    appdelegate.saveContext()
                    print("edited todo is saved")
                }
                tableView.reloadData()
                print("Text field: ",textField!.text!)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
            
        }
        
        editAction.backgroundColor = UIColor.green
        
    return [deleteAction, editAction]
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
    
    func configureCellForCategories(cell: CategoryTableCell,indexPath: IndexPath){
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
                let cell = tableview.cellForRow(at: indexPath) as! CategoryTableCell
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
