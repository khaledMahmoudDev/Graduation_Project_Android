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
    @IBOutlet weak var profileImg: UIImageView!
    
    var selectedImage: UIImage?
    
    let userDefault = UserDefaults.standard
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUp.handleSelectProfileImageView))
        profileImg.addGestureRecognizer(tapGesture)
        profileImg.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    
    @objc func handleSelectProfileImageView(){
        print("hooo")
        
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        present(imgPickerController, animated: true, completion: nil)
        
    }

    
    @IBAction func signUp(_ sender: Any) {
        if password.text != configPass.text{
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let Action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(Action)
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            
            
            guard let username = username.text, let email = email.text, let password = password.text else {return}
            
            
            
            Auth.auth().createUser(withEmail: email, password: password){ user, error in
                if error != nil{
                    print(error!)
                    self.performSegue(withIdentifier: "goToMain", sender: self)
                    //return
                }
                
                
                
                guard let uid = user?.user.uid else{
                    return
                }
                
                let storageRef = Storage.storage().reference(forURL: "gs://ajenda-a702f.appspot.com/").child("profileImages").child(uid)
                
                if let profileImage = self.selectedImage, let imageData = profileImage.jpegData(compressionQuality: 0.1){
                    
                    
                    
                    let ProfileImageURL = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                        guard let metadata = metadata else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        
                        storageRef.downloadURL(completion: { (url, error) in
                            if let err = error{
                                // error happened - implement code to handle it
                                print(err)
                            } else {
                                // no error happened; so just continue with your code
                               //print(url?.absoluteString) // this is the actual download url - the absolute string
                                let urlString: String = (url?.absoluteString) ?? ""
                                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                                let usersReference = self.ref.child("USERS").child(uid)
                                let values = ["username" : username , "email": email, "imageLink":urlString]
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
                            })

                        }
                        
                    }
                
            }
        }

    }
}

extension SignUp : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("selected")
        if let img = info[.originalImage] as? UIImage{
            selectedImage = img
            profileImg.image = img
        }
        dismiss(animated: true, completion: nil)
    }
}
