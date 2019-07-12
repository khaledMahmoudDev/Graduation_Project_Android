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
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .init(red: 30/255, green: 57/255, blue: 83/255, alpha: 1.00)
        self.navigationController?.navigationBar.isTranslucent = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarView?.backgroundColor = .init(red: 30/255, green: 57/255, blue: 83/255, alpha: 1.00)
        makeProfileImageRounded()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .utility).async {
            // do something time consuming here
            DispatchQueue.main.async {
                // now update UI on main thread
                self.fetchUserInformationFromFirebase()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
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
        ref = Database.database().reference().child("IOSUSERS").child(userID!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let usernameValue = value?["firstName"] as? String ?? ""
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
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func AccountSetting(_ sender: Any) {
        self.activityIndicator.stopAnimating()
        self.performSegue(withIdentifier: "AccountSettingTable", sender: self)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.activityIndicator.stopAnimating()
        self.dismiss(animated: true, completion: nil)
    }
    
}



    

