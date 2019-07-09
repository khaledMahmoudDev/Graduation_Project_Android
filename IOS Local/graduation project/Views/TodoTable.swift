//
//  TodoTable.swift
//  graduation project
//
//  Created by ahmed on 6/14/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase



class TodoTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var todoTable: UITableView!
    var ref: DatabaseReference!
    
    var firebaseArray = [TodoDone]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTodoFromFireBase()
        todoTable.delegate = self
        todoTable.dataSource = self
    }
    
    private var User : User? {
        return Auth.auth().currentUser
    }
    
    
  //  @IBOutlet weak var CatLabel: UILabel!
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if firebaseArray != nil{
           return firebaseArray.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ToDoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ToDoTableViewCell
        
        if firebaseArray[indexPath.row].priority == "red"{
            cell.title?.text = firebaseArray[indexPath.row].title
            cell.category?.text = firebaseArray[indexPath.row].category
            cell.category?.backgroundColor = UIColor.red
            cell.dateAndTime?.text = "\(firebaseArray[indexPath.row].date) \(firebaseArray[indexPath.row].time)"
        }else if firebaseArray[indexPath.row].priority == "yellow"{
            cell.title?.text = firebaseArray[indexPath.row].title
            cell.category?.text = firebaseArray[indexPath.row].category
            cell.category?.backgroundColor = UIColor.yellow
            cell.dateAndTime?.text = "\(firebaseArray[indexPath.row].date) \(firebaseArray[indexPath.row].time)"
        }else if firebaseArray[indexPath.row].priority == "green"{
            cell.title?.text = firebaseArray[indexPath.row].title
            cell.category?.text = firebaseArray[indexPath.row].category
            cell.category?.backgroundColor = UIColor.green
            cell.dateAndTime?.text = "\(firebaseArray[indexPath.row].date) \(firebaseArray[indexPath.row].time)"
        }else{
            cell.title?.text = firebaseArray[indexPath.row].title
            cell.category?.text = firebaseArray[indexPath.row].category
            cell.dateAndTime?.text = "\(firebaseArray[indexPath.row].date) \(firebaseArray[indexPath.row].time)"
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoKey = firebaseArray[indexPath.row].firebaseKey
        print("key", todoKey)
        performSegue(withIdentifier: "tododetails", sender: todoKey)
        todoTable.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            ref = Database.database().reference()
            let removeRef = ref.child("IOSUserTodo").child(User!.uid).child(firebaseArray[indexPath.row].firebaseKey)
            removeRef.removeValue()
            firebaseArray.remove(at: indexPath.row)
            todoTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("got here")
        if segue.identifier == "tododetails"{
            print("and here")
            if let destination = segue.destination as? UINavigationController{
                print("then here")
                let controller = (destination.topViewController as! ToDoCellDetails)
                if let selectedKey = sender as? String{
                    
                    controller.todoKey = selectedKey
                }

            }
        }
    }


  

    //controller.apptKey = choosedAppointment

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Main") as! MainViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = newViewController
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func AddToDo(_ sender: Any) {
         performSegue(withIdentifier: "addtodo", sender: self)
    }
    
    func fetchTodoFromFireBase(){
        
        ref = Database.database().reference()
        
        ref.child("IOSUserTodo").child(User!.uid).queryOrdered(byChild: "stats").queryEqual(toValue: "todo" ).observe(.value){ (snapshot) in
            print(snapshot)
            self.firebaseArray.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                if let dict = child.value as? NSDictionary{
                    
                    let title = dict["todoTitle"] as? String ?? "no title"
                    let time = dict["todoTime"] as? String ?? ""
                    let date = dict["todoDate"] as? String ?? ""
                    let category = dict["todoCategory"] as? String ?? ""
                    let priority = dict["todoPriority"] as? String ?? ""
                    let FIRKey = child.key
                    
                    let todoDone = TodoDone(titletxt: title, keytxt: FIRKey, dateTxt: date, timeTxt: time, categoryTxt: category, prioritytxt : priority)
                    self.firebaseArray.append(todoDone)
                    DispatchQueue.main.async { self.todoTable.reloadData() }
                        }
                        
    
                    }
    
    
            }
    }
}
