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
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        makeProfileImageRounded()
        
        DispatchQueue.global(qos: .utility).async {
            // do something time consuming here
            DispatchQueue.main.async {
                // now update UI on main thread
                self.fetchUserInformationFromFirebase()
            }
        }
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
        ref = Database.database().reference().child("USERS").child(userID!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let usernameValue = value?["username"] as? String ?? ""
            self.username.placeholder = "\(usernameValue)"
            
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
        updateUserName()
    }
    
    func updateUserName(){
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("USERS").child(userID!)
        if let newUserName = username.text {
            ref?.updateChildValues(["username": newUserName]) { (error, refrence) in
                if error == nil{
                    print("updated")
                    self.navigationController?.popViewController(animated: true)
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
        
        if let newImg = image.pngData(){
            storageRef.putData(newImg, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
        }
        
    }
    
}
}
