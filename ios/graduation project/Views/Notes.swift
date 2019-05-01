//
//  Notes.swift
//  graduation project
//
//  Created by farah on 2/23/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class Notes: UIViewController , UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var ref: DatabaseReference!
    var noteArray = [Note]()
    @IBOutlet weak var tableViewList: UITableView!

    //var controller : NSFetchedResultsController<UserNotes>!
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchNotesFromFirebase()
        //print("********************1")
        //getUniqueFirebaseKey()
        //fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.global(qos: .utility).async {
                // do something time consuming here
                DispatchQueue.main.async {
                    // now update UI on main thread
                   print("//////////////////////2")
                    self.fetchNotesFromFirebase()
                }
        }
        //fetch()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if let sections = controller.sections{
//            let secInfo = sections[section]
//            return secInfo.numberOfObjects
//        }
        
        return noteArray.count
        //return notelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NoteTableCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteTableCell
        
        //cell.mycell(note: notelist[indexPath.row])
       // configureCell(cell: cell, indexPath: indexPath )
        
        cell.textLabel?.text = noteArray[indexPath.row].noteName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
//    func configureCell(cell: NoteTableCell, indexPath: IndexPath) {
//        let noteitem = controller.object(at: indexPath )
//        cell.mycell(note: noteitem)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let obj = controller.fetchedObjects{
//            let note = obj[indexPath.row]
          // performSegue(withIdentifier: "noteDetails", sender: note)
        let choosenNote = noteArray[indexPath.row].noteKey
        print("choosenKey", choosenNote)
       performSegue(withIdentifier: "noteDetails", sender: choosenNote)
        self.noteArray.removeAll()
//        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            ref = Database.database().reference()
            let removeRef = ref.child("UserNotes").child(User!.uid).child(noteArray[indexPath.row].noteKey)
            removeRef.removeValue()
            noteArray.remove(at: indexPath.row)
            tableViewList.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete"){(action,indexPath) in
//            let obj = self.controller.fetchedObjects
//            let note = obj![indexPath.row]
//            context.delete(note)
//            appdelegate.saveContext()
//            print("deleted")
//        }
//        
//        return [deleteAction]
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteDetails"{
            if let destination = segue.destination as? NoteDetails{
                if let selectedNote = sender as? String{
                    
                    destination.choosedNote = selectedNote
                }

//                if let selectedNote = sender as? UserNotes{
//                    destination.editOrDeleteNote = selectedNote
//                }
            }
        }
    }
    
//    func fetch (){
//        let fetchRequest : NSFetchRequest<UserNotes> = UserNotes.fetchRequest()
//
//        let sortByDate = NSSortDescriptor(key: "date", ascending: false)
//        fetchRequest.sortDescriptors = [sortByDate]
//        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        controller.delegate = self
//        do{
//            //notelist = try context.fetch(fetchRequest)
//            try controller.performFetch()
//            tableViewList.reloadData()
//        }catch{
//            print("error")
//        }
//    }
//
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableViewList.beginUpdates()
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableViewList.endUpdates()
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch (type) {
//        case .insert:
//            if let indexPath = newIndexPath{
//                tableViewList.insertRows(at: [indexPath], with: .fade)
//            }
//            break
//        case .delete:
//            if let indexPath = indexPath{
//                tableViewList.deleteRows(at: [indexPath], with: .fade)
//            }
//            break
//        case .update:
//            if let indexPath = indexPath{
//                let cell = tableViewList.cellForRow(at: indexPath) as! NoteTableCell
//                configureCell(cell: cell, indexPath: indexPath )
//            }
//            break
//        case .move:
//            if let indexPath = indexPath{
//                tableViewList.deleteRows(at: [indexPath], with: .fade)
//            }
//            if let indexPath = newIndexPath{
//                tableViewList.insertRows(at: [indexPath], with: .fade)
//            }
//            break
//        }
//
//
//    }
    
    
    private var User : User? {
        return Auth.auth().currentUser
    }
    
    func fetchNotesFromFirebase(){
        Database.database().reference().ref.child("UserNotes").child(User!.uid).observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let noteName = dict["noteName"] as! String
                let noteKey = snapshot.key
                print("this is note key", noteKey)
                let notes = Note(noteNametxt: noteName, noteKeytxt: noteKey)
                self.noteArray.append(notes)
                self.tableViewList.reloadData()
                print("fetched")
            }
            
        }
    }
    
    
//    func getUniqueFirebaseKey(){
//        let ref = Database.database().reference()
//        ref.child("UserNotes").child(User!.uid)
//            .queryEqual(toValue: "UNIQUE_ID")
//            .observe(.value, with: { (snapshot) in
//
//                if let dict = snapshot.value as? [String:Any] {
//
//                    for key in dict.keys{
//                        print("this is key from loop ", key)
//                    }
//                }
//        }
//
//    )}
  

}
