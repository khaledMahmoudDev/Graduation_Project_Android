//
//  Profile.swift
//  graduation project
//
//  Created by farah on 2/5/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase



class Profile: UIViewController {
    
    var ref: DatabaseReference!
    
    var reference: StorageReference!

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let user = Auth.auth().currentUser
//        if let user = user {
//            let emailValue = user.email
//            print("this uid in easy way",email!)
//            email.text = emailValue
//            let usernameValue = user.displayName
//            username.text = usernameValue
////            let profileImageURL = user.photoURL
////            let data = NSData(contentsOf: profileImageURL!)
////            let image = UIImage(data: data! as Data)
////            profileImage.image = image
//
//        }

        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("USERS").child(userID!)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value

            let value = snapshot.value as? NSDictionary

            let usernameValue = value?["username"] as? String ?? ""
            self.username.text = "\(usernameValue)"

            let emailValue = value?["email"] as? String ?? ""
            self.email.text = "\(emailValue)"

        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        let storageRef = Storage.storage().reference(forURL: "gs://ajenda-a702f.appspot.com/").child("profileImages").child(userID!)

        storageRef.downloadURL { url, error in
            if let error = error {
                // Handle any errors
                print(error)
            } else {
                // Get the download URL for 'images/stars.jpg'
//                                let UrlString = url!.absoluteString
//                                print(UrlString)

                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                self.profileImage.image = image
            }
        }
  
    }
  
    @IBAction func LogoutBtn(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            
            let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigation") as! LoginNavigation
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = login
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
}




    

