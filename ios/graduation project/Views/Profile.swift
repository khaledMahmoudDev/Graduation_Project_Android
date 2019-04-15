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
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let emailValue = Auth.auth().currentUser?.email else {return}
        email.text = emailValue
        
    }
    

    @IBAction func logOut(_ sender: Any) {

        do {
            try Auth.auth().signOut()
            userDefault.removeObject(forKey: "signedIn")
            userDefault.synchronize()
            let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigation") as! LoginNavigation
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = login
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}
