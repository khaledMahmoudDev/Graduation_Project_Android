//
//  EditUserProfile.swift
//  graduation project
//
//  Created by ahmed on 5/10/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

class EditUserProfile: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    var reference: StorageReference!
    var selectedImage = UIImage(named: "profileImg.png")
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    
    static var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.hideKeyboardWhenTappedAround()
        
        //EditUserProfile.flag = 0
        
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
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        profileImage.image = image
        self.dismiss(animated: true, completion: nil)
        EditUserProfile.flag = 1
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
            updateUserName()
            if EditUserProfile.flag == 1{
                updateProfileImage()
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            let alert =  UIAlertController(title: "ERROR", message: "You can't set username as empty., Please set a username", preferredStyle: .alert)
            let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func updateUserName(){
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("IOSUSERS").child(userID!)
        if let newUserName = username.text {
            ref?.updateChildValues(["firstName": newUserName]) { (error, refrence) in
                if error == nil{
                    print("username updated")
                }else{
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
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
                
//                                if let updatedProfileImg = url?.absoluteString{
//                                    let updatedvalues = ["imageLink":updatedProfileImg]
//                                    self.ref = Database.database().reference()
//                                    let usersReference = self.ref.child("IOSUSERS").child(userID!)
//                                    usersReference.updateChildValues(updatedvalues, withCompletionBlock: { (error, ref) in
//                                        if error != nil{
//                                            print(error!)
//                                            return
//                                        }
//                                        print("image is updated")
//                                    })
//                                }
                
                
                
                
                if let err = error{
                    print(err)
                } else {

//                    print(url?.absoluteString) // this is the actual download url - the absolute string
//                    guard let newUserName = self.username.text else {return}
                    let urlString: String = (url?.absoluteString) ?? ""
                    let values = ["imageLink":urlString]
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
//extension EditUserProfile : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//
//
//
//
//    //to set the selected image into the UIImage view
////    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
////        print("selected")
////
////        self.dismiss(animated: true, completion: nil)
////        var chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
////        profileImage.image = chosenImage
////        EditUserProfile.flag = 1
////
//////        if let img = info[.originalImage] as? UIImage{
//////            selectedImage = img
//////            profileImage.image = img
//////            EditUserProfile.flag = 1
//////        }
//////        dismiss(animated: true, completion: nil)
////    }
//}

