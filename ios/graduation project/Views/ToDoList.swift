//
//  ToDoList.swift
//  graduation project
//
//  Created by farah on 2/25/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class ToDoList: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(Add))
//        self.navigationItem.leftBarButtonItem = addButton
        
//        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
//        self.view.addSubview(navBar);
//
//        let navItem = UINavigationItem(title: "SomeTitle")
//        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(Add))
//        navItem.rightBarButtonItem = doneItem
//
//        navBar.setItems([navItem], animated: false)
    }
    
 
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "add", sender: nil)
    }
    

    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    }

    


