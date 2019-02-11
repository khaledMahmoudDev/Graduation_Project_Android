//
//  SignUp.swift
//  graduation project
//
//  Created by farah on 2/5/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUp: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
  
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var configPass: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func signUp(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!){ user, error in
            
            if error == nil || user != nil{
                
                print("user created")
                self.performSegue(withIdentifier: "goToMain", sender: self)
            }else{
                print("error\(error!.localizedDescription)")
//                self.performSegue(withIdentifier: "goToMain", sender: self)
                
            }
            
        }
    }
    
}
