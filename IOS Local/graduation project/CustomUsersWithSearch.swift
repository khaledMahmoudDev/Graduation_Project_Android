//
//  CustomUsersWithSearch.swift
//  graduation project
//
//  Created by ahmed on 6/25/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

protocol SendSelectedUsers{
    func setSelectedUsers (selected : Array<String>)
}

class CustomUsersWithSearch: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var ref: DatabaseReference!
    var reference: StorageReference!
    var usersEmailArray = [CustomUsersEmail]()
    var selectedUsersEmailArray : Array<String> = []
    
    var searchOnUsers : [CustomUsersEmail] = []
    var searchActive = false
    
    var delegate: SendSelectedUsers!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsersFromFirebase()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.navigationController?.navigationBar.barTintColor = .init(red: 71/255, green: 130/255, blue: 143/255, alpha: 1.00)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
    }
    

    @IBAction func DoneUsersSelectionButton(_ sender: Any) {
        if selectedUsersEmailArray != []{
            self.delegate.setSelectedUsers(selected: selectedUsersEmailArray)
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            return searchOnUsers.count
        }
        
        return usersEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomUserCell
        
        cell.userImage.layer.borderWidth = 1
        cell.userImage.layer.masksToBounds = false
        cell.userImage.layer.borderColor = UIColor.lightGray.cgColor
        cell.userImage.layer.cornerRadius = cell.userImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        cell.userImage.clipsToBounds = true
        
        if searchActive{
            cell.userEmail?.text = searchOnUsers[indexPath.row].usersEmail
            cell.userName?.text = searchOnUsers[indexPath.row].userName
            cell.userImage?.image = UIImage(named : "facebook100")
            cell.userImage?.image = searchOnUsers[indexPath.row].userImage
        }else{
            cell.userEmail?.text = usersEmailArray[indexPath.row].usersEmail
            cell.userName?.text = usersEmailArray[indexPath.row].userName
            cell.userImage?.image = UIImage(named : "facebook100")
            cell.userImage?.image = usersEmailArray[indexPath.row].userImage
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventCreator = usersEmailArray[indexPath.row].usersEmail
        self.selectedUsersEmailArray.append(eventCreator)
        print("hooo", selectedUsersEmailArray)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //let deselectEventCreator = usersEmailArray[indexPath.row].usersEmail
        self.selectedUsersEmailArray.remove(at: indexPath.row)
        print("deleted", selectedUsersEmailArray)
    }
    
    private var User : User? {
        return Auth.auth().currentUser
    }
    
    func fetchUsersFromFirebase(){
        ref = Database.database().reference()
        ref.child("IOSUSERS").observe(.value) { (snapshot) in
            self.usersEmailArray.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                if let url = child.value as? [String : Any]{
                    let UserEmail = url["email"] as! String
                    print(UserEmail)
                    let UserName = url["firstName"] as! String
                    let UserImage = url["imageLink"] as! String
                    let Url = URL (string: UserImage)!
                    let request = URLRequest(url: Url)
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if error != nil {
                            print(error)
                            return
                        }
                        DispatchQueue.main.async {
                            let image = UIImage(data: data!)
                            let Users = CustomUsersEmail(usersEmailtxt : UserEmail, userNametxt: UserName ,userImageImg : image!)
                            
                            if self.User?.email != UserEmail{
                                self.usersEmailArray.append(Users)
                                self.tableView.reloadData()
                                self.ref.keepSynced(true)
                            }else{
                                print("current user")
                            }
                            
                            
                        }
                    }
                    task.resume()
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
    }
}

extension CustomUsersWithSearch {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //searchOnUsers = usersEmailArray
        
        
        func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
            searchActive = true
        }
        
        func searchBarTextDidEndEditing(searchBar: UISearchBar) {
            searchActive = false
        }
        
        func searchBarCancelButtonClicked(searchBar: UISearchBar) {
            searchActive = false
        }
        
        func searchBarSearchButtonClicked(searchBar: UISearchBar) {
            searchActive = false
        }
        
        
        searchOnUsers = usersEmailArray.filter({ (text) -> Bool in
            let temp = text.usersEmail as NSString
            let range = temp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive )
            tableView.reloadData()
            return range.location != NSNotFound
        })
        
        searchOnUsers = usersEmailArray.filter({ (text) -> Bool in
            let temp = text.userName as NSString
            let range = temp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive )
            tableView.reloadData()
            return range.location != NSNotFound
        })
        
        if (searchOnUsers.count == 0){
            
            searchActive = false
            
        }else{
            searchActive = true
        }
        tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        self.tableView.reloadData()
    }
}
