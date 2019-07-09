//
//  TodoTable.swift
//  graduation project
//
//  Created by ahmed on 6/14/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

var list = ["todo1", "todo2"]


class TodoTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var PriorityLabel: UILabel!
    
    @IBOutlet weak var todoTable: UITableView!
    
    
  //  @IBOutlet weak var CatLabel: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "todocell")
        
        cell.textLabel?.text = list[indexPath.row]
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tododetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            list.remove(at: indexPath.row)
            todoTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        todoTable.reloadData()
    }
    
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
    
    
}
