//
//  DeleteUser.swift
//  graduation project
//
//  Created by ahmed on 5/5/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

class DeleteUser: UIViewController {
    
    var ref: DatabaseReference!
    var credential: AuthCredential!

    @IBOutlet weak var userPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func deleteAccount(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser, let userId = Auth.auth().currentUser?.uid, let pass = userPassword.text else{
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: pass)
        
        user.reauthenticateAndRetrieveData(with: credential, completion: {(result, error) in
            if error != nil {
                // An error happened.
                print(error!.localizedDescription)
            }else{
                // User re-authenticated.
                user.delete { error in
                    if let error = error {
                        // An error happened.
                        print(error.localizedDescription)
                    } else {
                        // Account deleted.
                        self.ref = Database.database().reference()
                        self.ref.child("USERS").child(userId).removeValue()
                        print("user is removed")
                        
                        try!  Auth.auth().signOut()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        })
        
        
    }
    
}
