//
//  CustomUsers.swift
//  graduation project
//
//  Created by ahmed on 6/21/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

protocol SendSelectedUsers{
    //Replace parameter with DeliveryDestinations
    func setSelectedUsers (selected : Array<String>)
}

class CustomUsers: UITableViewController {
    
    var ref: DatabaseReference!
    var reference: StorageReference!
    var usersEmailArray = [CustomUsersEmail]()
    var selectedUsersEmailArray : Array<String> = []
    
    var delegate: SendSelectedUsers?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersEmailArray.removeAll()
        fetchUsersFromFirebase()
        
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true

    }


    @IBAction func SlectedUsersButton(_ sender: Any) {
        if delegate != nil {
            if selectedUsersEmailArray != nil {
                
               
                //add that object to previous view with delegate
                delegate?.setSelectedUsers (selected : selectedUsersEmailArray)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return usersEmailArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomUserCell
     
        cell.userEmail?.text = usersEmailArray[indexPath.row].usersEmail
        cell.userName?.text = usersEmailArray[indexPath.row].userName
        cell.userImage?.image = UIImage(named : "facebook100")
        cell.userImage?.image = usersEmailArray[indexPath.row].userImage
        return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventCreator = usersEmailArray[indexPath.row].usersEmail
        let selectedUser = CustomUsersSelected(selectedUsersEmailtxt: eventCreator)
        //self.selectedUsersEmailArray.append(selectedUser)
    }
     
    
    func fetchUsersFromFirebase(){
        ref = Database.database().reference()
        ref.child("USERS").observe(.childAdded) { (snapshot) in
            //if let dict = snapshot.value as? [String : Any]{
                
//                let UserEmail = dict["email"] as! String
//                print(UserEmail)
//                let UserName = "label"//dict["username"] as! String
                
                if let url = snapshot.value as? [String : Any] {
                    let UserEmail = url["email"] as! String
                    print(UserEmail)
                    let UserName = "label"
                    let UserImage = url["imageLink"] as! String
                    let Url = URL (string: UserImage)!
                    let request = URLRequest(url: Url)
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if error != nil {
                            print("mother fucker error", error)
                            return
                        }
                        DispatchQueue.main.async {
                            print("Oh ya")
                            let image = UIImage(data: data!)
                            let Users = CustomUsersEmail(usersEmailtxt : UserEmail, userNametxt: UserName ,userImageImg : image!)
                            self.usersEmailArray.append(Users)
                            self.tableView.reloadData()
                            self.ref.keepSynced(true)
                            print("fetched info")
                        }
                    }
                    task.resume()
                }


                self.tableView.reloadData()

                }
            }
        }

//}
