//
//  SignUp.swift
//  graduation project
//
//  Created by farah on 2/5/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase


class SignUp: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var ref: DatabaseReference!

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var configPass: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    static var flag = 1
    
    
    
    var selectedImage = UIImage(named: "profileImg.png")
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg.image = selectedImage
        
        self.navigationController?.navigationBar.barTintColor = .init(red: 30/255, green: 57/255, blue: 83/255, alpha: 1.00)
        self.navigationController?.navigationBar.isTranslucent = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.hideKeyboardWhenTappedAround() 
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUp.handleSelectProfileImageView))
        profileImg.addGestureRecognizer(tapGesture)
        profileImg.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.activityIndicator.stopAnimating()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //this func is here so we can go to the image gallery on the phone(UIImagePickerController)
    @objc func handleSelectProfileImageView(){
        print("hooo")
        
        //        let imgPickerController = UIImagePickerController()
        //        imgPickerController.delegate = self
        //        imgPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        //        imgPickerController.allowsEditing = false
        //        present(imgPickerController, animated: true, completion: nil)
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //selected image
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImage = image
            profileImg.image = selectedImage
        }
        
        self.dismiss(animated: true, completion: nil)
        
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
                    let alert = UIAlertController(title: "Verification", message: "Verification mail has been sent.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        
                        self.activityIndicator.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            })
        }
        else {
            // Either the user is not available, or the user is already verified.
        }
   
       
    }

    //creating an new user
    
    func setUserInfoInFirebase(){
        guard let username = username.text, let email = email.text, let password = password.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password){ user, error in
            if let err = error {
                
                if (err as NSError).code == 17008{
                    
                    let alert = UIAlertController(title: "ERROR", message: "The email address is badly formatted. ", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else if(err as NSError).code == 17007{
                    
                    let alert = UIAlertController(title: "ERROR", message: "The email address is already in use by another account.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else if (err as NSError).code == 17026{
                    
                    let alert = UIAlertController(title: "ERROR", message: "password must be 6 characters long or more.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else if (err as NSError).code == 17020{
                    
                    let alert = UIAlertController(title: "ERROR", message: "Network error (such as timeout, interrupted connection or unreachable host) has occurred.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else if (err as NSError).code == 17034{
                    
                    let alert = UIAlertController(title: "ERROR", message: "An email address must be provided.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    print("ok")
                }
                
                print("error0000000000000",err)
                //return
            }else{
                
            }
                guard let uid = user?.user.uid else{
                    return
                }
                
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                
                
                let storageRef = Storage.storage().reference(forURL: "gs://ajenda-a702f.appspot.com/").child("profileImages").child(uid)
                guard let image = self.profileImg.image else{
                    return
                }
            if let newImg = self.profileImg.image?.jpegData(compressionQuality: 0.75){
                    storageRef.putData(newImg, metadata: nil) { (metadata, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        storageRef.downloadURL(completion: { (url, error) in
                            if let err = error{
                                print(err)
                            } else {
                                let urlString: String = (url?.absoluteString) ?? ""
                                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                                let values = ["firstName" : username , "email": email, "imageLink":urlString]
                                self.ref.child("IOSUSERS").child(uid).setValue(values)
                                let reference = self.ref.child("IOSUSERS").child(uid)
                                reference.updateChildValues(values, withCompletionBlock :{
                                    (err, ref) in
                                    if err != nil{
                                        print(err!)
                                        return
                                    }
                                    self.sendVerificationMail()
                                })
                            }
                        })
                    }
                
                

            
            }
        
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        setUserInfoInFirebase()
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
