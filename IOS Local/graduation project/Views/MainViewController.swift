//
//  MainViewController.swift
//  graduation project
//
//  Created by farah on 7/6/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = .init(red: 71/255, green: 130/255, blue: 143/255, alpha: 1.00)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Are you sure, you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "logout", sender: self)
                //self.dismiss(animated: true, completion: nil)
                //self.navigationController?.popToRootViewController(animated: true)
                //self.navigationController?.popToViewController(Login(), animated: true)
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarView?.backgroundColor = .init(red: 71/255, green: 130/255, blue: 143/255, alpha: 1.00)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
}
}