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
        
        self.hideKeyboardWhenTappedAround() 
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if Auth.auth().currentUser != nil{
            self.performSegue(withIdentifier: "goToMainEntry", sender: self)
        }
        
    }
    

 
    @IBAction func signIn(_ sender: Any) {
        
        
        guard let email = signInEmail.text , let pass = signInPassword.text else{ return }
        
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            
            if let authresult = user {
                let verifiedUser = authresult.user
                if verifiedUser.isEmailVerified{
                    print("this email is verified")
                    self.performSegue(withIdentifier: "goToMainEntry", sender: self)
                }else{
                    print("EEEEEEEEEror ", error?.localizedDescription)
                    print("this mail is not verified")
                    let alert =  UIAlertController(title: "ERROR", message: "This Email is not verified, please verify your email address.", preferredStyle: .alert)
                    let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OKButton)
                    self.present(alert, animated: true, completion: nil)

                }
            }else if user == nil && (error?._code == AuthErrorCode.userNotFound.rawValue){
                
                let alert =  UIAlertController(title: "ERROR", message: "User Not Found", preferredStyle: .alert)
                let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKButton)
                self.present(alert, animated: true, completion: nil)
                
                
            }else if error != nil || (error?._code == AuthErrorCode.wrongPassword.rawValue){
                let alert =  UIAlertController(title: "ERROR", message: "Invalid Email or Password.", preferredStyle: .alert)
                let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKButton)
                self.present(alert, animated: true, completion: nil)
            }

        }
        
    }
    
    @IBAction func ResetPassword(_ sender: Any) {
        
        performSegue(withIdentifier: "ResetPassword", sender: self)
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        
//      self.performSegue(withIdentifier: "signUp", sender: self)
        let goToSignUp = storyboard?.instantiateViewController(withIdentifier: "signUp")
        self.navigationController?.pushViewController(goToSignUp!, animated: true)
    }
    
}

