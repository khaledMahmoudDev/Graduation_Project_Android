//
//  Profile.swift
//  graduation project
//
//  Created by farah on 2/5/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase


class Profile: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let emailValue = Auth.auth().currentUser?.email else {return}
        email.text = emailValue
        
    }
    

    @IBAction func logOut(_ sender: Any) {

        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "logOut", sender: self)
            //self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}
