//
//  MainEntry.swift
//  graduation project
//
//  Created by farah on 2/6/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class MainEntry: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var MainEntryTableView: UITableView!
    
    let segueIdentifiers = ["calendar","todo","notification","email","notes","location","weather"]
    let tableContent = ["Calendar","To Do","Notification","Email","Notes","Location","Weather"]
    
    let tableContentimages = [UIImage(named: "calendar"), UIImage(named: "todo"), UIImage(named: "notification"), UIImage(named: "email"), UIImage(named: "note"), UIImage(named: "location"), UIImage(named: "weather")]
  
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
        
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        MainEntryTableView.reloadData()
    }
    
    @objc func profile(){
        let newNote = storyboard?.instantiateViewController(withIdentifier: "profile")
        self.navigationController?.pushViewController(newNote!, animated: true)
    }
    
    @objc func search(){
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainEntryTableCell
        let mainContent = self.tableContent[indexPath .row]
        let mainImages = tableContentimages[indexPath .row]
        let rightArrow = UIImage(named : "rightarrow.png")
        let rightArrowView = UIImageView(image: rightArrow)
        cell.mainLabel.text = mainContent
        cell.mainImage.image = mainImages
        cell.accessoryView = rightArrowView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: segueIdentifiers[indexPath.row], sender: self)
    }
    


}
