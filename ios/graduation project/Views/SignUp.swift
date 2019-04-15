//
//  SignUp.swift
//  graduation project
//
//  Created by farah on 2/5/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

class SignUp: UIViewController{
    
    var ref: DatabaseReference!

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var configPass: UITextField!
    
    let userDefault = UserDefaults.standard
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func signUp(_ sender: Any) {
        if password.text != configPass.text{
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let Action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(Action)
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            
            
            guard let username = username.text, let email = email.text, let password = password.text, let configPass = configPass.text else {return}
            
            
            
            Auth.auth().createUser(withEmail: email, password: password){ user, error in
                if error != nil{
                    print(error!)
                    self.performSegue(withIdentifier: "goToMain", sender: self)
                    //return
                }
                
                guard let uid = user?.user.uid else{
                    return
                }
                
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let usersReference = self.ref.child("USERS").child(uid)
                 let values = ["username" : username , "email": email]
                usersReference.updateChildValues(values, withCompletionBlock :{
                    (err, ref) in
                    if err != nil{
                        print(err!)
                        return
                    }
                    self.performSegue(withIdentifier: "goToMain", sender: self)
                    self.dismiss(animated: true, completion: nil)
                    
                    print("saved user successfully into firebase db")
                    
                } )
                
        }
    }

    

}
}
