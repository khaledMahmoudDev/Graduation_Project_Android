//
//  ToDoCellDetails.swift
//  graduation project
//
//  Created by ahmed on 6/14/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase




var priorityColor = ""


class ToDoCellDetails: UIViewController , UITextViewDelegate {
    
    
    var categChoosen = "None"
    
    static var category = 0
    static var priority = 0
    var ref: DatabaseReference!
    var todoKey : String!
    
    @IBOutlet weak var Priority: UILabel!
    @IBOutlet weak var ToDoTitle: UITextField!
    @IBOutlet weak var ToDoDetail: UITextView!
    @IBOutlet weak var ToDoCategory: UITextField!
    
    
    @IBOutlet weak var moveToDoneOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .init(red: 71/255, green: 130/255, blue: 143/255, alpha: 1.00)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
        ToDoCellDetails.category = 0
        ToDoCellDetails.priority = 0
        ToDoDetail.delegate = self
        
        if todoKey != nil{
            fetchTodoFromFirebase()
            moveToDoneOutlet.isHidden = false
        }else{
            ToDoTitle.text = ""
            ToDoDetail.text = ""
            ToDoCategory.text = ""
            Priority.backgroundColor = UIColor.clear
            moveToDoneOutlet.isHidden = true
        }
        
        print(ToDoCellDetails.category )
        
        
    }
    
    
    @IBAction func Shopping(_ sender: Any) {
        ToDoCellDetails.category = 1
        categChoosen = "Shopping"
        ToDoCategory.text = categChoosen
    }
    @IBAction func Work(_ sender: Any) {
        ToDoCellDetails.category = 2
        categChoosen = "Work"
        ToDoCategory.text = categChoosen
    }
    
    @IBAction func Fun(_ sender: Any) {
        ToDoCellDetails.category = 3
        categChoosen = "Fun"
        ToDoCategory.text = categChoosen
    }
    
    @IBAction func None(_ sender: Any) {
        ToDoCellDetails.category = 4
        categChoosen = "None"
        ToDoCategory.text = categChoosen
    }
    
    
    
    //save button to save a todo in the table view
    
    @IBAction func saveTodo(_ sender: Any) {
        
        
        if (ToDoTitle.text != "" && ToDoDetail.text != "" && ToDoCategory.text != ""){
            
            var title = ToDoTitle.text
            var details = ToDoDetail.text
            var cat = ToDoCategory.text
            
            if todoKey != nil{
                updateToDoInFirebase()
                print("updated")
                
            }else{
                saveToDoInFirebase()
                print("saved")
            }
            
            ToDoTitle.text = ""
            ToDoDetail.text = ""
            ToDoCategory.text = ""
            
            self.dismiss(animated: true, completion: nil)
            //save the category in category label in todo table
        }else{
            let alert = UIAlertController(title: "", message: "Please,fill in all the fields.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func MoveToDone(_ sender: Any) {
        
        DoneList.append(ToDoTitle.text!)
       // list.remove(at: index(ofAccessibilityElement: self))
        if todoKey != nil{
            moveToDoneInFireBase()
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        ToDoDetail.text = ""
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (ToDoDetail.text == "")
        {
            ToDoDetail.text = "Details"
        }
    }
    
    @IBAction func HighPr(_ sender: Any) {
        ToDoCellDetails.priority = 1
        Priority.backgroundColor = UIColor.red
        priorityColor = "red"
    }
    
    @IBAction func MiddlePr(_ sender: Any) {
        ToDoCellDetails.priority = 2
        Priority.backgroundColor = UIColor.yellow
        priorityColor = "yellow"

    }
    @IBAction func LowPr(_ sender: Any) {
        ToDoCellDetails.priority = 3
        Priority.backgroundColor = UIColor.green
        priorityColor = "green"

    }
    
    
    private var User : User? {
        return Auth.auth().currentUser
    }
    
    func saveToDoInFirebase(){
        
        guard let todoTitle = ToDoTitle.text, let todoDetails = ToDoDetail.text, let todoCategory = ToDoCategory.text else{
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let defaultDate = dateFormatter.string(from: NSDate() as Date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "H:mm"
        let defaultTime = timeFormatter.string(from: NSDate() as Date)
        let time = timeFormatter.date(from: defaultTime )!
        let dateInHourFormatter = hourFormatter(date: time
        )
        print("time am pm ",dateInHourFormatter)
        
        if ToDoCellDetails.category == 1 {
            if ToDoCellDetails.priority == 1{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "red" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }else if ToDoCellDetails.priority == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "yellow" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }else if ToDoCellDetails.priority == 3{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "green" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }else{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }
            
            
            print("saved savely for the current user")
        }else if ToDoCellDetails.category == 2{
            
            if ToDoCellDetails.priority == 1{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "red" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }else if ToDoCellDetails.priority == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "yellow" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }else if ToDoCellDetails.priority == 3{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "green" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }else{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }
            
            
        }else if ToDoCellDetails.category == 3{
            if ToDoCellDetails.priority == 1{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "red" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }else if ToDoCellDetails.priority == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "yellow" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }else if ToDoCellDetails.priority == 3{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "green" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }else{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }
            
            print("saved savely for the current user")
            
        }else if ToDoCellDetails.category == 4{
            if ToDoCellDetails.priority == 1{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "red" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }else if ToDoCellDetails.priority == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "yellow" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }else if ToDoCellDetails.priority == 3{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "green" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }else{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).childByAutoId().setValue(values)
                
            }
            
            print("saved savely for the current user")
            
        }
        
        
    }
    
    
    func fetchTodoFromFirebase(){
        
        
        let userId = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("IOSUserTodo").child(userId!).child(todoKey)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.ToDoTitle.text = value?["todoTitle"] as? String ?? ""
            self.ToDoDetail.text = value?["todoDetails"] as? String ?? ""
            let category = value?["todoCategory"] as? String ?? ""
            
            if category == "Shopping"{
                ToDoCellDetails.category = 1
                self.ToDoCategory.text = category
            }else if category == "Work"{
                ToDoCellDetails.category = 2
                self.ToDoCategory.text = category
            }else if category == "Fun"{
                ToDoCellDetails.category = 3
                self.ToDoCategory.text = category
            }else if category == "None"{
                ToDoCellDetails.category = 4
                self.ToDoCategory.text = category
            }
            
            
            let prioityBackgoundColor = value?["todoPriority"] as? String ?? ""
            print(prioityBackgoundColor)
            
            if prioityBackgoundColor == "red"{
                ToDoCellDetails.priority = 1
                self.Priority.backgroundColor = UIColor.red
            }else if prioityBackgoundColor == "yellow"{
                ToDoCellDetails.priority = 2
                self.Priority.backgroundColor = UIColor.yellow
            }else if prioityBackgoundColor == "green"{
                ToDoCellDetails.priority = 3
                self.Priority.backgroundColor = UIColor.green
            }
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateToDoInFirebase(){
        
        guard let todoTitle = ToDoTitle.text, let todoDetails = ToDoDetail.text, let todoCategory = ToDoCategory.text else{
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let defaultDate = dateFormatter.string(from: NSDate() as Date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "H:mm"
        let defaultTime = timeFormatter.string(from: NSDate() as Date)
        let time = timeFormatter.date(from: defaultTime )!
        let dateInHourFormatter = hourFormatter(date: time
        )
        print("time am pm ",dateInHourFormatter)
        
        if ToDoCellDetails.category == 1 {
            if ToDoCellDetails.priority == 1{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "red" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "yellow" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 3{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "green" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }
            
            
            print("saved savely for the current user")
        }else if ToDoCellDetails.category == 2{
            
            if ToDoCellDetails.priority == 1{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "red" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "yellow" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 3{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "green" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }
            
            
        }else if ToDoCellDetails.category == 3{
            if ToDoCellDetails.priority == 1{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "red" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "yellow" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 3{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "green" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }
            
            print("saved savely for the current user")
            
        }else if ToDoCellDetails.category == 4{
            if ToDoCellDetails.priority == 1{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "red" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "yellow" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 3{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "green" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "todo"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }
            
            print("saved savely for the current user")
            
        }
        
    }
    
    func moveToDoneInFireBase(){
        guard let todoTitle = ToDoTitle.text, let todoDetails = ToDoDetail.text, let todoCategory = ToDoCategory.text else{
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let defaultDate = dateFormatter.string(from: NSDate() as Date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "H:mm"
        let defaultTime = timeFormatter.string(from: NSDate() as Date)
        let time = timeFormatter.date(from: defaultTime )!
        let dateInHourFormatter = hourFormatter(date: time
        )
        print("time am pm ",dateInHourFormatter)
        
        if ToDoCellDetails.category == 1 {
            if ToDoCellDetails.priority == 1{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "red" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "yellow" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 3{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "green" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }
            
            
            print("saved savely for the current user")
        }else if ToDoCellDetails.category == 2{
            
            if ToDoCellDetails.priority == 1{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "red" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "yellow" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 3{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "green" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }
            
            
        }else if ToDoCellDetails.category == 3{
            if ToDoCellDetails.priority == 1{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "red" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "yellow" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 3{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "green" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }
            
            print("saved savely for the current user")
            
        }else if ToDoCellDetails.category == 4{
            if ToDoCellDetails.priority == 1{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "red" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "yellow" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else if ToDoCellDetails.priority == 3{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "green" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }else{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["todoTitle" : todoTitle , "todoDetails": todoDetails, "todoCategory": todoCategory, "todoPriority": "" ,"todoDate": defaultDate, "todoTime": dateInHourFormatter, "state": "done"]
                self.ref.child("IOSUserTodo").child(User!.uid).child(todoKey).updateChildValues(values)
                
            }
            
            print("saved savely for the current user")
            
        }
    }
    
}
