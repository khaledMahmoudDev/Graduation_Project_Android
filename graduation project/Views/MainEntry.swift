//
//  MainEntry.swift
//  graduation project
//
//  Created by farah on 2/6/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class MainEntry: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //let identifiers = ["calendar","notification","notes","location","weather"]
    let segueIdentifiers = ["calendar","todo","notification","email","notes","location","weather"]
    let tableContent = ["Calendar","To Do","Notification","Email","Notes","Location","Weather"]
    @IBOutlet weak var MainEntryTableView: UITableView!
  
    override func viewDidLoad() {
     
        super.viewDidLoad()
        //MainEntryTableView.delegate = self
        //MainEntryTableView.dataSource = self
       // MainEntryTableView.reloadData()
        
        let profileButton = UIButton(type: .custom)
        profileButton.setImage(UIImage(named: "planet.png"), for: .normal)
        profileButton.addTarget(self, action: #selector(profile), for: .touchUpInside)
        profileButton.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        let barButton = UIBarButtonItem(customView: profileButton)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func profile(){
        let newNote = storyboard?.instantiateViewController(withIdentifier: "profile")
        self.navigationController?.pushViewController(newNote!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableContent [indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: segueIdentifiers[indexPath.row], sender: self)
        
//        let vc = identifiers [indexPath.row]
//        let viewControllers = storyboard?.instantiateViewController(withIdentifier: vc)
//        self.navigationController?.pushViewController(viewControllers!, animated: true)
        
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
