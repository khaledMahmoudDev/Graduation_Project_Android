//
//  Notes.swift
//  graduation project
//
//  Created by farah on 2/6/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData



 let appDelegate = UIApplication.shared.delegate as? AppDelegate

class Notes: UIViewController{
  
    @IBOutlet weak var tableView: UITableView!
    
    var window: UIWindow?
    var item :[Any] = []
    var dict = NSMutableDictionary()
    let appdelegate =    UIApplication.shared.delegate as!   AppDelegate
    var noteArray = [Note]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callDelegates()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(NewNote))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
        
    }
    
    
    @objc func NewNote(){
        let newNote = storyboard?.instantiateViewController(withIdentifier: "NewNoteDetails")
        self.navigationController?.pushViewController(newNote!, animated: true)
    }
    
    func fetchData(){
    
    fetchData{(done) in
    if done{
    if noteArray.count > 0{
    tableView.isHidden = false
    }else{
    tableView.isHidden = true
                }
            }
        }
    
    }
    
    func callDelegates(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
    }

}


extension Notes: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int
    {
        //return noteArray.count
        return item.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableCell
        
//        let note = noteArray[indexPath.row]
//        cell.noteTitle.text = note.title
//        cell.noteContent.text = note.content
//        return cell
        
        let dic = item[indexPath.row]  as! NSManagedObject
        cell.noteTitle?.text = dic.value(forKey: "title" ) as? String
        cell.noteContent?.text = dic.value(forKey: "content" )  as? String
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    /*func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete"){(action,indexPath) in
            //self.deleteNote(indexpath: indexPath)
            self.fetchData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        return [deleteAction]
    }*/
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
             let updatevc = self.storyboard?.instantiateViewController(withIdentifier:"UpdateNoteDetails") as! updateNoteDetails
             let temp = self.item[indexPath.row] as! NSManagedObject
             getrecord = temp
             self.navigationController?.pushViewController(updatevc, animated: true)
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete"){(action,indexPath) in
            //self.deleteNote(indexpath: indexPath)
            //self.fetchData()
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            let temp = self.item[indexPath.row] as! NSManagedObject
            let noteTitle = temp.value(forKey: "title")
            let context = self.appdelegate.persistentContainer.viewContext
            let entitydec = NSEntityDescription.entity(forEntityName: "Note", in:
                context)
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            request.entity = entitydec
            let pred = NSPredicate(format: "title = %@", noteTitle as! CVarArg)
            request.predicate = pred
            do
            {
                let result = try context.fetch(request)
                if result.count > 0
                {
                    let manage = result[0] as! NSManagedObject
                    context.delete(manage)
                    try context.save()
                    print("Record Deleted")
                }
                else
                {
                    print("Record Not Found")
                }
            }
            catch {}
            self.item.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .middle)
            self.tableView.reloadData()
            
        }

        return [deleteAction, editAction]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let updateNoteVc = self.storyboard?.instantiateViewController(withIdentifier:"UpdateNoteDetails") as! updateNoteDetails
        let temp = self.item[indexPath.row] as! NSManagedObject
        getrecord = temp
        self.navigationController?.pushViewController(updateNoteVc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
    
}

extension Notes{
    func fetchData(completion:(_ complet :Bool) -> ()){

        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchRequest.returnsObjectsAsFaults = false
        do{
        noteArray = try! context.fetch(fetchRequest) as! [Note]
            item.removeAll()
        for noteArr in noteArray
        {
            item.append(noteArr)
        }
            
            completion(true)
            print("data fetch complet")
        }catch{
            print("unable to fetch data from CoreData",error.localizedDescription)
            completion(false)
            print("didn't fetch data")
        }
        
    }
    
 /*   func deleteNote(indexpath: IndexPath){
       
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        managedContext.delete(noteArray[indexpath.row])
        do{
            try managedContext.save()
            print("deleted")
        }catch{
            print("not deleted", error.localizedDescription)
        }
     
   
    }

*/
    
}