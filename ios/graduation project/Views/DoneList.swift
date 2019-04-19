//
//  DoneList.swift
//  graduation project
//
//  Created by farah on 2/25/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData

class DoneList: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var tableview: UITableView!
    
    var controller : NSFetchedResultsController<DoneItems>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDoneItems()

    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
        let cell = tableview.dequeueReusableCell(withIdentifier: "donecell", for: indexPath) as! DoneTableCell
        configureCellForDone(cell: cell, indexPath: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func configureCellForDone(cell: DoneTableCell,indexPath: IndexPath){
        let itemChosen = controller.object(at: indexPath)
        cell.doneCell(item: itemChosen)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let obj = controller.fetchedObjects{
            let done = obj[indexPath.row]
            performSegue(withIdentifier: "goFromDoneToDetails", sender: done)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goFromDoneToDetails"{
            if let dest = segue.destination as? ToDoDetails {
                if let item = sender as? DoneItems{
                    dest.editOrEditDone = item
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete"){(action,indexPath) in
            let obj = self.controller.fetchedObjects
            let note = obj![indexPath.row]
            context.delete(note)
            appdelegate.saveContext()
            print("deleted")
        }
        
        return [deleteAction]
    }
    
    func loadDoneItems(){
        let fetchrequest:NSFetchRequest<DoneItems>=DoneItems.fetchRequest()
        
        let itemDateAdded = NSSortDescriptor (key: "donedate", ascending: false)
        fetchrequest.sortDescriptors = [itemDateAdded]
        controller=NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.endUpdates()
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
                let cell = tableview.cellForRow(at: indexPath) as! DoneTableCell
                configureCellForDone(cell: cell, indexPath: indexPath )
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
