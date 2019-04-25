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
    
    var reference :DatabaseReference!
    
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let emailValue = Auth.auth().currentUser?.email else {return}
        print(emailValue)
        email.text = emailValue
        
        
//        //let userID = Auth.auth().currentUser?.uid
//        reference.child("USERS").child(emailValue).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            let usernamedata = value?["username"] as? String ?? ""
//
//            print(usernamedata)
//            //let user = User(username: username)
//
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
        
//        reference.observeSingleEvent(of: .value, with: { (snapshot) in
//                        // Get user value
//            print(snapshot)
////                        let value = snapshot.value as? NSDictionary
////                        let usernamedata = value?["username"] as? String ?? ""
////
////                        print(usernamedata)
////                        //let user = User(username: username)
////
////                        // ...
////                    }) { (error) in
////                        print(error.localizedDescription)
//                    }
//    )}

     // your ref ie. root.child("users").child("stephenwarren001@yahoo.com")
    
    // only need to fetch once so use single event
    
//    reference.observeSingleEventOfType(.Value, withBlock: { snapshot in
//
//    if !snapshot.exists() { return }
//
//    //print(snapshot)
//
//    if let userName = snapshot.value["username"] as? String {
//    print(userName)
//    }
//    if let email = snapshot.value["email"] as? String {
//    print(email)
//    }
//
//    // can also use
//    // snapshot.childSnapshotForPath("full_name").value as! String
//    })


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
