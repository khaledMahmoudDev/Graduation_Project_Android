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
        navigationController?.navigationBar.tintColor = .white
        self.hideKeyboardWhenTappedAround()

    }
    

  
    @IBAction func restPass(_ sender: Any) {
        guard let user = Auth.auth().currentUser ,let newPass = newPassword.text, let currPass = currPassword.text else{
            return
        }
        
        
        if newPass != "" || currPass != ""{
        
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currPass)
        
        user.reauthenticateAndRetrieveData(with: credential, completion: {(result, error) in
            if error != nil {
                // An error happened.
                print("here",error!.localizedDescription)
                if error!.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred."{
                    
                    let alert =  UIAlertController(title: "NETWORK ERROR", message: "Please try again", preferredStyle: .alert)
                    let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OKButton)
                    self.present(alert, animated: true, completion: nil)
                    
                }else if error!.localizedDescription == "The password is invalid or the user does not have a password."{
                    let alert =  UIAlertController(title: "ERROR", message: "The password is invalid, Please re-enter the passwprd again", preferredStyle: .alert)
                    let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OKButton)
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                // User re-authenticated.
                user.updatePassword(to: newPass) { (error) in
                    // ...
                    
                    if error != nil {
                        print("there is an error !!")
                        print(error!.localizedDescription)
                        if error!.localizedDescription == "The password must be 6 characters long or more." {
                            
                            let alert =  UIAlertController(title: "ERROR", message: "The password must be 6 characters long or more.", preferredStyle: .alert)
                            let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(OKButton)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                      
                    }else{
                        do {
                            // handle your signout smth like:
                            print("password has been updated")
                            try Auth.auth().signOut()
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                            appdelegate.window!.rootViewController = newViewController
                            self.dismiss(animated: true, completion: nil)
                        } catch let logoutError {
                            // handle your error here
                            print("second error")
                            print(logoutError)
                        }
                    }
                }
            }
        })
    }else{
            let alert =  UIAlertController(title: "ERROR", message: "You can't leave any of these two fields empty", preferredStyle: .alert)
            let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKButton)
            self.present(alert, animated: true, completion: nil)
    }
    
}



}
