//
//  ProfileSettingTable.swift
//  graduation project
//
//  Created by ahmed on 5/3/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

class ProfileSettingTable: UITableViewController {
    
    let segueId = ["EditUserProfile", "userResetPass","deleteUser"]
    let tableSettingContent = ["Edit Profile", "Change Password", "Delete Account"]
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableSettingContent.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        
        let cell = UITableViewCell(style: .default ,reuseIdentifier: "settingCell")
        cell.textLabel?.text = tableSettingContent[indexPath.row]
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            performSegue(withIdentifier: segueId[indexPath.row], sender: self)
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
