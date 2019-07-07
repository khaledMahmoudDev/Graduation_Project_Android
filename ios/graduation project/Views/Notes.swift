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
//import RealmSwift

class Notes: UIViewController , UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var ref: DatabaseReference!
    var noteArray = [Note]()
    @IBOutlet weak var tableViewList: UITableView!
    static var flag = 0

    //var controller : NSFetchedResultsController<UserNotes>!
    
    
    var isWillAppearLoadedFirstTime = false
    var isDidLoadLoadedFirsttime = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Notes.flag == 0{
            if isDidLoadLoadedFirsttime{
                self.noteArray.removeAll()
                fetchNotesFromFirebase()
                print("can1")
            }
            isDidLoadLoadedFirsttime = true

            isWillAppearLoadedFirstTime = true
        }else{
            print("can't")
        }
        
        //this fetch was for coreData
        //fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if Notes.flag == 1{
            isDidLoadLoadedFirsttime = true

            if !isWillAppearLoadedFirstTime {
                 //Do what you want to do when it is not the first load
                self.noteArray.removeAll()
                self.tableViewList.reloadData()
                self.fetchNotesFromFirebase()
                print("can1")
                
            }
            isWillAppearLoadedFirstTime = false
        }else{
            print("can't2")
        }
        
        //this fetch was for coreData
        //fetch()
    }
    
    
    @IBAction func AddNewNote(_ sender: Any) {
        Notes.flag = 1
        performSegue(withIdentifier: "noteDetails", sender: self)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if let sections = controller.sections{
//            let secInfo = sections[section]
//            return secInfo.numberOfObjects
//        }
        if noteArray != nil{
            return noteArray.count
        }else{
            return 0
        }

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NoteTableCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteTableCell
        
        //cell.mycell(note: notelist[indexPath.row])
       // configureCell(cell: cell, indexPath: indexPath )
        
        cell.name?.text = noteArray[indexPath.row].noteName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
    
    
    //to delete note
    //we set the array index which we want to delete in variable "noteArrayIndexPath"
    //by using ref we are making refrence from firebase database so we can access the firebase database
    //the path will contain that specific we want to delete
    //removeValue remove the object from firbase db
    //then to delete it from realm
    //we get all the objects from realmFile then we do that filting given it thet specific index so it gets it only to do the delete operation
    //to do the delete operation it must be done within name of the realmFile.write to accept the changes that the deletion operation has made
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            ref = Database.database().reference()
            let removeRef = ref.child("IOSUserNotes").child(User!.uid).child(noteArray[indexPath.row].noteKey)
            removeRef.removeValue()
            noteArray.remove(at: indexPath.row)
            
//            var choosenNoteToDelete = noteRealmFile.objects(NoteRealmObjects.self).filter("noteKeyRealm = '\(noteArrayIndexPath!)'")
//            try! noteRealmFile.write {
//               noteRealmFile.delete(choosenNoteToDelete)
//            }
            
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
    
    
    //fetching data from firebase and save it in realm database so it can be viewd in the tableview
    
    func fetchNotesFromFirebase(){
        guard let userId = Auth.auth().currentUser?.uid else{
            return
        }
        ref = Database.database().reference()
        ref.child("IOSUserNotes").child(User!.uid).observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                
                let noteName = dict["noteName"] as! String
                let noteKey = snapshot.key
                print("this is note key", noteKey)
                
                let notes = Note(noteNametxt: noteName, noteKeytxt: noteKey)
                self.noteArray.append(notes)
                self.tableViewList.reloadData()
                self.ref.keepSynced(true)
                print("fetched")

               
            }
            
        }
    }
    

}
