//
//  EditCustomUsersWithSearch.swift
//  graduation project
//
//  Created by farah on 6/30/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase


protocol SendEditedSelectedUsers{
    func setEditedSelectedUsers (selected : Array<String>)
}

class EditCustomUsersWithSearch: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var ref: DatabaseReference!
    var reference: StorageReference!
    var usersEmailArray = [CustomUsersEmail]()
    var editSelectedUsersEmailArray : Array<String> = []
    var fetchedArrayFromFireBase : Array<String> = []
    var searchOnUsers : [CustomUsersEmail] = []
    var searchActive = false
    var checkForCustomUserIsSelected = false
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    let indexPath = NSIndexPath(row: 0, section: 0)
//    let cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomUserCell
    
    
    var delegate: SendEditedSelectedUsers!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // tableView.contentInset = UIEdgeInsets(top: -30,left: 0,bottom: 0,right: 0)
        usersEmailArray.removeAll()
        fetchUsersFromFirebase()
        if fetchedArrayFromFireBase != []{
            self.editSelectedUsersEmailArray.append(contentsOf: self.fetchedArrayFromFireBase)
        }
        print("view didload",editSelectedUsersEmailArray)
        
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    @IBAction func DoneSelection(_ sender: Any) {
        self.delegate.setEditedSelectedUsers(selected: editSelectedUsersEmailArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.delegate.setEditedSelectedUsers(selected: editSelectedUsersEmailArray)
        self.navigationController?.popViewController(animated: true)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomUserCell
        
        cell.userImage.layer.borderWidth = 1
        cell.userImage.layer.masksToBounds = false
        cell.userImage.layer.borderColor = UIColor.lightGray.cgColor
        cell.userImage.layer.cornerRadius = cell.userImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        cell.userImage.clipsToBounds = true
        
        if fetchedArrayFromFireBase.contains(usersEmailArray[indexPath.row].usersEmail){
                cell.isSelected = true
                cell.accessoryType = .checkmark
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
                cell.isHighlighted = true
            }else{
                cell.isSelected = false
                cell.accessoryType = .none
                cell.isHighlighted = false
                tableView.deselectRow(at: indexPath, animated: false)

            }


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
        if fetchedArrayFromFireBase.contains(eventCreator){
//            tableView.deselectRow(at: indexPath, animated: true)
//            self.fetchedArrayFromFireBase.remove(at: indexPath.row)
//            print(self.fetchedArrayFromFireBase)
//            self.editSelectedUsersEmailArray.remove(at: indexPath.row)
//            tableView.reloadData()
            print("deleted", editSelectedUsersEmailArray)
        }else{
            self.editSelectedUsersEmailArray.append(eventCreator)
            print("appended", editSelectedUsersEmailArray)
        }

        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let eventCreator = usersEmailArray[indexPath.row].usersEmail
        if fetchedArrayFromFireBase.contains(eventCreator){
            if let editedIndex = self.editSelectedUsersEmailArray.firstIndex(of: eventCreator){
                self.editSelectedUsersEmailArray.remove(at: editedIndex)
            }
            if let fetchedIndex = self.fetchedArrayFromFireBase.firstIndex(of: eventCreator){
                self.fetchedArrayFromFireBase.remove(at: fetchedIndex)
            }
            print(self.fetchedArrayFromFireBase)
            
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
            print("edited array", editSelectedUsersEmailArray)
            
        }
        print("deleted", editSelectedUsersEmailArray)
    }
    
    private var User : User? {
        return Auth.auth().currentUser
    }
    
    func fetchUsersFromFirebase(){
        ref = Database.database().reference()
        ref.child("IOSUSERS").observe(.childAdded) { (snapshot) in
            
            
            if let url = snapshot.value as? [String : Any] {
                let UserEmail = url["email"] as! String
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

extension EditCustomUsersWithSearch {
    
    
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
