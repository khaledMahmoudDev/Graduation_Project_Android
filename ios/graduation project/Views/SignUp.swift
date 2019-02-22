//
//  SignUp.swift
//  graduation project
//
//  Created by farah on 2/5/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SignUp: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var configPass: UITextField!
    
    let userDefault = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func signUp(_ sender: Any) {
        if password.text != configPass.text{
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let Action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(Action)
            self.present(alertController, animated: true, completion: nil)
            
        }else{
        Auth.auth().createUser(withEmail: email.text!, password: password.text!){ result, error in
            
            if error == nil || result != nil{
                
                print("user created")
                self.userDefault.set(true, forKey: "signedIn")
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "goToMain", sender: self)
            }else{
                print("error\(error!.localizedDescription)")
//                self.performSegue(withIdentifier: "goToMain", sender: self)
                }
            }
            
        }
    }

    

}
