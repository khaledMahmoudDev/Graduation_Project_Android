//
//  UserResetPassword.swift
//  graduation project
//
//  Created by ahmed on 5/4/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

class UserResetPassword: UIViewController {

    var ref: DatabaseReference!
    var credential: AuthCredential!
    
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var currPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  
    @IBAction func restPass(_ sender: Any) {
        guard let user = Auth.auth().currentUser ,let userId = Auth.auth().currentUser?.uid ,let newPass = newPassword.text, let currPass = currPassword.text else{
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currPass)
        
        user.reauthenticateAndRetrieveData(with: credential, completion: {(result, error) in
            if error != nil {
                // An error happened.
                print(error!.localizedDescription)
            }else{
                // User re-authenticated.
                user.updatePassword(to: newPass) { (error) in
                    // ...
                    
                    if error != nil {
                        print("there is an error !!")
                        print(error!.localizedDescription)
                    }else{
                        do {
                            // handle your signout smth like:
                            print("password has been updated")
                            try Auth.auth().signOut()
                            self.navigationController?.popToRootViewController(animated: true)
                        } catch let logoutError {
                            // handle your error here
                            print("second error")
                            print(logoutError)
                        }
                    }
                }
            }
        })
    }
    
    
}








//////for deletion

//
//guard let currUser = Auth.auth().currentUser ,let userID = Auth.auth().currentUser?.uid else{
//    return
//}
//var credential: AuthCredential
//
//currUser.reauthenticate(with:credential) { error in
//    if let error = error {
//        // An error happened.
//        print(error.localizedDescription)
//    } else {
//        // User re-authenticated.
//        currUser.delete { error in
//            if let error = error {
//                // An error happened.
//                print(error.localizedDescription)
//            } else {
//                // Account deleted.
//                self.ref = Database.database().reference()
//                self.ref.child("USERS").child(userID).removeValue()
//
//                try!  Auth.auth().signOut()
//                self.navigationController?.popToRootViewController(animated: true)
//            }
//        }
//
//    }
//    print("Try again later")
//}
