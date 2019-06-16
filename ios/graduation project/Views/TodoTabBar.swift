//
//  TodoTabBar.swift
//  graduation project
//
//  Created by ahmed on 6/16/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class TodoTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.leftBarButtonItem = addButton

        // Do any additional setup after loading the view.
    }
    
    @objc func add(){
        performSegue(withIdentifier: "addtodo", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
