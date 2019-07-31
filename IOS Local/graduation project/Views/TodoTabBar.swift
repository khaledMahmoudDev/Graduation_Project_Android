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
        tabBar.isTranslucent = false
        
        tabBar.barTintColor = .init(red: 71/255, green: 130/255, blue: 143/255, alpha: 1.00)
        self.tabBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .init(red: 71/255, green: 130/255, blue: 143/255, alpha: 1.00)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

        // Do any additional setup after loading the view.
    
    
//    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
//    self.navigationItem.leftBarButtonItem = addButton
    
}

//@objc func add(){
//    performSegue(withIdentifier: "addtodo", sender: self)
//}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
