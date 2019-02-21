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
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "signedIn"){
            self.performSegue(withIdentifier: "goToMainEntry", sender: self)
        }
    }
    

 
    @IBAction func signIn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: signInEmail.text!, password: signInPassword.text!){
            (user, error) in
            if user != nil{
                self.userDefault.set(true, forKey: "signedIn")
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "goToMainEntry", sender: self)
            }else if (error?._code == AuthErrorCode.userNotFound.rawValue){
                
                let alert =  UIAlertController(title: "User Not Found", message: "There is no such user", preferredStyle: .alert)
                
                let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKButton)
                self.present(alert, animated: true, completion: nil)

                
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
