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
    
    var selectedImage = UIImage(named: "profileImg.png")
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUp.handleSelectProfileImageView))
        profileImg.addGestureRecognizer(tapGesture)
        profileImg.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    //this func is here so we can go to the image gallery on the phone(UIImagePickerController)
    @objc func handleSelectProfileImageView(){
        print("hooo")
        
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        present(imgPickerController, animated: true, completion: nil)
        
    }
    
    // to send verification email when creating an account
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    public func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                // Notify the user that the mail has sent or couldn't because of an error.
                if error != nil{
                    print(error!)
                }else{
                    print("okay verification mail has been sent")
                }
            })
        }
        else {
            // Either the user is not available, or the user is already verified.
        }
   
       
    }

    //creating an new user
    
    @IBAction func signUp(_ sender: Any) {
        
        // checks if the password matches with the second entered password
        if password.text != configPass.text{
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let Action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(Action)
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            
            //set labels in constnat variabes for faster use
            guard let username = username.text, let email = email.text, let password = password.text, let configPass = configPass.text , let profileImg = profileImg.image else {return}
            
            
            //creating the new account with email and password
            Auth.auth().createUser(withEmail: email, password: password){ user, error in
                if let err = error {
                    
                    if (err as NSError).code == 17008{
                        
                        let alert = UIAlertController(title: "ERROR", message: "The email address is badly formatted. ", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if(err as NSError).code == 17007{
                        
                        let alert = UIAlertController(title: "ERROR", message: "The email address is already in use by another account.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if (err as NSError).code == 17026{
                        
                        let alert = UIAlertController(title: "ERROR", message: "password must be 6 characters long or more.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)

                    }
                    else if (err as NSError).code == 17020{
                        
                        let alert = UIAlertController(title: "ERROR", message: "Network error (such as timeout, interrupted connection or unreachable host) has occurred.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else if (err as NSError).code == 17034{
                        
                        let alert = UIAlertController(title: "ERROR", message: "An email address must be provided.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        print("ok")
                    }
                    
                    print("error0000000000000",err)
                    //return
                }else{
                    self.sendVerificationMail()
                }

                
                guard let uid = user?.user.uid else{
                    return
                }
                
                //making a refrence from firebase storage to used it in uploading the profile image
                let storageRef = Storage.storage().reference(forURL: "gs://ajenda-a702f.appspot.com/").child("profileImages").child(uid)
                
                if let profileImage = self.selectedImage, let imageData = profileImage.jpegData(compressionQuality: 0.1){
                    
                    
                    //uploading the profile image and image info into the firebase storage
                let ProfileImageURL = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                        guard let metadata = metadata else {
                            // Uh-oh, an error occurred!
                            return
                    }
                    
                    //making the image as a url and set it in the firebase database with the other information of the user such as username, email
                    
                        storageRef.downloadURL(completion: { (url, error) in
                            if let err = error{
                                // error happened - implement code to handle it
                                print("error88888888888",err)
                            } else {
                                // no error happened; so just continue with your code
                               //print(url?.absoluteString) // this is the actual download url - the absolute string
                                let urlString: String = (url?.absoluteString) ?? ""
                                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                                let usersReference = self.ref.child("USERS").child(uid)
                                let values = ["username" : username , "email": email, "imageLink":urlString]
                                usersReference.updateChildValues(values, withCompletionBlock :{
                                    (error, ref) in
                                    if let err = error{
                                        print("err*********",err)
                                        return
                                    }
                                 
                                    print("saved user successfully into firebase db")
                                    
                                    } )
                                
                                }
                            })

                        }
                        
                    }
            }
//            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.popViewController(animated: true)
         //self.navigationController?.popToRootViewController(animated: true)

    }
}

extension SignUp : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    //to set the selected image into the UIImage view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("selected")
        if let img = info[.originalImage] as? UIImage{
            selectedImage = img
            profileImg.image = img
        }
        dismiss(animated: true, completion: nil)
    }
}
