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
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.hideKeyboardWhenTappedAround() 
    }
    

    @IBAction func deleteAccount(_ sender: Any) {
        
        if userPassword.text != ""{
            
            let alert =  UIAlertController(title: "Are you sure you want to delete your account?", message: "Deleting your account means you will lose all your data.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.activityIndicator.center = self.view.center
                self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.style = UIActivityIndicatorView.Style.white
                self.view.addSubview(self.activityIndicator)
                self.activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                self.deleteUseraccount()
            }))
            
            present(alert, animated: true, completion: nil)
        
        }else{
            
            let alert =  UIAlertController(title: "ERROR", message: "You can't leave your password fields empty, Please enter your password.", preferredStyle: .alert)
            let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKButton)
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    func deleteUseraccount(){
        
        
        guard let user = Auth.auth().currentUser, let userId = Auth.auth().currentUser?.uid, let pass = userPassword.text else{
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: pass)
        
        user.reauthenticateAndRetrieveData(with: credential, completion: {(result, error) in
            if error != nil {
                // An error happened.
                print("here1",error!.localizedDescription)
                if error!.localizedDescription == "The password is invalid or the user does not have a password."{
                    let alert =  UIAlertController(title: "ERROR", message: "The password is invalid, Please re-enter the passwprd again", preferredStyle: .alert)
                    let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OKButton)
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.present(alert, animated: true, completion: nil)
                }else if error!.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred."{
                    
                    let alert =  UIAlertController(title: "NETWORK ERROR", message: "Please try again", preferredStyle: .alert)
                    let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OKButton)
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }else{
                // User re-authenticated.
                user.delete { error in
                    if let error = error {
                        // An error happened.
                        print("here2",error.localizedDescription)
                    } else {
                        // Account deleted.
                        self.ref = Database.database().reference()
                        self.ref.child("IOSUSERS").child(userId).removeValue()
                        self.ref.child("IOSEvents").child(userId).removeValue()
                        self.ref.child("IOSUserNotes").child(userId).removeValue()
                        print("user is removed")
                        
                        try!  Auth.auth().signOut()
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
                        let appdelegate = UIApplication.shared.delegate as! AppDelegate
                        appdelegate.window!.rootViewController = newViewController
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        })
        
    }
    
}
