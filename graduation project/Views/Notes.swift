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
    
    let cellId = "noteCell"
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
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableCell
        
        let note = noteArray[indexPath.row]
        cell.noteTitle.text = note.title
        cell.noteContent.text = note.content
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete"){(action,indexPath) in
            self.deleteNote(indexpath: indexPath)
            self.fetchData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        return [deleteAction]
    }
    
    
}

extension Notes{
    func fetchData(completion:(_ complet :Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        do{
            noteArray = try managedContext.fetch(request) as! [Note]
            completion(true)
            print("data fetch complet")
        }catch{
            print("unable to fetch data from CoreData",error.localizedDescription)
            completion(false)
            print("didn't fetch data")
        }
        
    }
    
    func deleteNote(indexpath: IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        managedContext.delete(noteArray[indexpath.row])
        do{
            try managedContext.save()
            print("deleted")
        }catch{
            print("not deleted", error.localizedDescription)
        }
        
        
    }
}
