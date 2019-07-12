//
//  DoneTable.swift
//  graduation project
//
//  Created by ahmed on 6/15/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

var DoneList = ["done1","done2"]

class DoneTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var ref: DatabaseReference!
    
    var firebaseArray = [TodoDone]()

    @IBOutlet weak var DoneTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .init(red: 71/255, green: 130/255, blue: 143/255, alpha: 1.00)
        self.navigationController?.navigationBar.isTranslucent = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        fetchDoneFromFireBase()
        // Do any additional setup after loading the view.
    }
    
    private var User : User? {
        return Auth.auth().currentUser
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Main") as! MainViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = newViewController
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if firebaseArray != nil{
            return firebaseArray.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DoneTableCell = tableView.dequeueReusableCell(withIdentifier: "donecell", for: indexPath) as! DoneTableCell
        
        if firebaseArray[indexPath.row].priority == "red"{
            cell.title?.text = firebaseArray[indexPath.row].title
            cell.category?.text = firebaseArray[indexPath.row].category
            cell.category?.backgroundColor = UIColor.red
            cell.timeAndDate?.text = "\(firebaseArray[indexPath.row].date) \(firebaseArray[indexPath.row].time)"
        }else if firebaseArray[indexPath.row].priority == "yellow"{
            cell.title?.text = firebaseArray[indexPath.row].title
            cell.category?.text = firebaseArray[indexPath.row].category
            cell.category?.backgroundColor = UIColor.yellow
            cell.timeAndDate?.text = "\(firebaseArray[indexPath.row].date) \(firebaseArray[indexPath.row].time)"
        }else if firebaseArray[indexPath.row].priority == "green"{
            cell.title?.text = firebaseArray[indexPath.row].title
            cell.category?.text = firebaseArray[indexPath.row].category
            cell.category?.backgroundColor = UIColor.green
            cell.timeAndDate?.text = "\(firebaseArray[indexPath.row].date) \(firebaseArray[indexPath.row].time)"
        }else{
            cell.title?.text = firebaseArray[indexPath.row].title
            cell.category?.text = firebaseArray[indexPath.row].category
            cell.timeAndDate?.text = "\(firebaseArray[indexPath.row].date) \(firebaseArray[indexPath.row].time)"
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let doneKey = firebaseArray[indexPath.row].firebaseKey
        performSegue(withIdentifier: "donedetails", sender: doneKey)
        DoneTable.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "donedetails"{
            if let destination = segue.destination as? UINavigationController{
                let controller = (destination.topViewController as! DoneDetails)
                if let selectedKey = sender as? String{
                    
                    controller.doneKey = selectedKey
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            ref = Database.database().reference()
            let removeRef = ref.child("IOSUserTodo").child(User!.uid).child(firebaseArray[indexPath.row].firebaseKey)
            removeRef.removeValue()
            firebaseArray.remove(at: indexPath.row)
            DoneTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func fetchDoneFromFireBase(){
        
        ref = Database.database().reference()
        
        ref.child("IOSUserTodo").child(User!.uid).queryOrdered(byChild: "state").queryEqual(toValue: "done" ).observe(.value){ (snapshot) in
            print(snapshot)
            self.firebaseArray.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                if let dict = child.value as? NSDictionary{
                    
                    let title = dict["todoTitle"] as? String ?? ""
                    let time = dict["todoTime"] as? String ?? ""
                    let date = dict["todoDate"] as? String ?? ""
                    let category = dict["todoCategory"] as? String ?? ""
                    let priority = dict["todoPriority"] as? String ?? ""
                    let FIRKey = child.key
                    
                    let todoDone = TodoDone(titletxt: title, keytxt: FIRKey, dateTxt: date, timeTxt: time, categoryTxt: category, prioritytxt : priority)
                    self.firebaseArray.append(todoDone)
                    DispatchQueue.main.async { self.DoneTable.reloadData() }
                }
                
                
            }
            
            
        }
    }
    
    
    
   
  

}
