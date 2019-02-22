//
//  Login.swift
//  graduation project
//
//  Created by farah on 2/5/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class Login: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInEmail: UITextField!
    @IBOutlet weak var signInPassword: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
//        signInButton.layer.cornerRadius = signInButton.frame.size.width/2
//        signInButton.clipsToBounds = true
//        signInButton.layer.borderColor = UIColor.white.cgColor
//        signInButton.layer.borderWidth = 5.0
        
//        let image = UIImage(named: "gmail50")
//        let imageView = UIImageView(image: image!)
//        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 60)
//        signInButton.addSubview(imageView)

        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "signedIn"){
            self.performSegue(withIdentifier: "goToMainEntry", sender: self)
        }
    }
    

 
    @IBAction func signIn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: signInEmail.text!, password: signInPassword.text!){
            (result, error) in
            if result != nil{
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
    
    
    
   /* @IBAction func LoginWithGmail(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate=self as? GIDSignInDelegate
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }*/
}
