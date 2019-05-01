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

        DispatchQueue.global(qos: .utility).async {
            // do something time consuming here
            DispatchQueue.main.async {
                // now update UI on main thread
                self.fetchUserInformationFromFirebase()
            }
        }
  
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//    }
    
    func fetchUserInformationFromFirebase(){
        
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




    

