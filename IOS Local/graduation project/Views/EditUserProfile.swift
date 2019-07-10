//
//  EditUserProfile.swift
//  graduation project
//
//  Created by ahmed on 5/10/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

class EditUserProfile: UIViewController {
    
    var ref: DatabaseReference!
    var reference: StorageReference!
    var selectedImage = UIImage(named: "profileImg.png")
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        self.hideKeyboardWhenTappedAround() 
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUp.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        makeProfileImageRounded()
        
        DispatchQueue.global(qos: .utility).async {
            // do something time consuming here
            DispatchQueue.main.async {
                // now update UI on main thread
                self.fetchUserInformationFromFirebase()
            }
        }
        
    }
    
    //this func is here so we can go to the image gallery on the phone(UIImagePickerController)
    @objc func handleSelectProfileImageView(){
        print("hooo")
        
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        present(imgPickerController, animated: true, completion: nil)
        
    }
    
    func makeProfileImageRounded() {
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        profileImage.clipsToBounds = true
    }
    
    func fetchUserInformationFromFirebase(){
        
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("IOSUSERS").child(userID!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let usernameValue = value?["firstName"] as? String ?? ""
            self.username.text = "\(usernameValue)"
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        let storageRef = Storage.storage().reference(forURL: "gs://ajenda-a702f.appspot.com/").child("profileImages").child(userID!)
        
        storageRef.downloadURL { url, error in
            if let error = error {
                // Handle any errors
                print(error)
            } else {
                
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                self.profileImage.image = image
            }
        }
    }
    
    @IBAction func saveUserUpdates(_ sender: Any) {
        //updateUserName()
        if username.text != ""{
            updateProfileImage()
            self.navigationController?.popViewController(animated: true)
        }else{
            let alert =  UIAlertController(title: "ERROR", message: "You can't set username as empty., Please set a username", preferredStyle: .alert)
            let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
//    func updateUserName(){
//        let userID = Auth.auth().currentUser?.uid
//        ref = Database.database().reference().child("USERS").child(userID!)
//        if let newUserName = username.text {
//            ref?.updateChildValues(["username": newUserName]) { (error, refrence) in
//                if error == nil{
//                    print("username updated")
//                }else{
//                    print(error?.localizedDescription)
//                }
//            }
//        }
//    }
    
    func updateProfileImage(){
        
        let userID = Auth.auth().currentUser?.uid
        let storageRef = Storage.storage().reference(forURL: "gs://ajenda-a702f.appspot.com/").child("profileImages").child(userID!)
        guard let image = profileImage.image else{
            return
        }
        
        if let newImg = image.jpegData(compressionQuality: 0.1){
            storageRef.putData(newImg, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                
                //                if let updatedProfileImg = url?.absoluteString{
                //                    guard let newUserName = self.username.text else {return}
                //
                //                    let updatedvalues = ["username" : newUserName , "imageLink":updatedProfileImg]
                //                    self.ref = Database.database().reference()
                //                    let usersReference = self.ref.child("USERS").child(userID!)
                //                    usersReference.updateChildValues(updatedvalues, withCompletionBlock: { (error, ref) in
                //                        if error != nil{
                //                            print(error!)
                //                            return
                //                        }
                //                        print("profile updated1")
                //                    })
                //                }
                //
                
                
                
                if let err = error{
                    print(err)
                } else {
                    
                    print(url?.absoluteString) // this is the actual download url - the absolute string
                    guard let newUserName = self.username.text else {return}
                    let urlString: String = (url?.absoluteString) ?? ""
                    let values = ["username" : newUserName , "imageLink":urlString]
                    self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                    let usersReference = self.ref.child("IOSUSERS").child(userID!)
                    usersReference.updateChildValues(values, withCompletionBlock :{
                        (err, ref) in
                        if err != nil{
                            print(err!)
                            return
                        }
                        print("profile updated2")
                        
                        
                        
                    } )
                }
                
                
                
                
                
            })
            
        }
        
    }
}
extension EditUserProfile : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    //to set the selected image into the UIImage view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("selected")
        if let img = info[.originalImage] as? UIImage{
            selectedImage = img
            profileImage.image = img
        }
        dismiss(animated: true, completion: nil)
    }
}

