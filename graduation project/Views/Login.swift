//
//  Login.swift
//  graduation project
//
//  Created by farah on 2/5/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import FirebaseAuth

class Login: UIViewController {

    @IBOutlet weak var signInEmail: UITextField!
    
    @IBOutlet weak var signInPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

 
    @IBAction func signIn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: signInEmail.text!, password: signInPassword.text!){
            (user, error) in
            if user != nil{
                self.performSegue(withIdentifier: "goToMainEntry", sender: self)
            }else{
                let alert =  UIAlertController(title: "Invalid Sign In", message: "your email or password may be wrong", preferredStyle: .alert)

                let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKButton)
                self.present(alert, animated: true, completion: nil)
//                self.performSegue(withIdentifier: "goToMainEntry", sender: self)
//                print("...")
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        
//      self.performSegue(withIdentifier: "signUp", sender: self)
        let goToSignUp = storyboard?.instantiateViewController(withIdentifier: "signUp")
        self.navigationController?.pushViewController(goToSignUp!, animated: true)
    }
    
}
