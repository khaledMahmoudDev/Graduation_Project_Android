//
//  DoneDetails.swift
//  graduation project
//
//  Created by ahmed on 6/15/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

class DoneDetails: UIViewController {

    
    //variables declared just to show data in view will appear
    @IBOutlet weak var DoneTitle: UITextField!
    
    @IBOutlet weak var DoneDetails: UITextView!
    
    @IBOutlet weak var categoryLabel: UITextField!
    
    var doneKey : String!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .init(red: 71/255, green: 130/255, blue: 143/255, alpha: 1.00)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
        fetchDoneFromFirebase()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func OKDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func fetchDoneFromFirebase(){
        let userId = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("IOSUserTodo").child(userId!).child(doneKey)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.DoneTitle.text = value?["todoTitle"] as? String ?? ""
            self.DoneDetails.text = value?["todoDetails"] as? String ?? ""
            self.categoryLabel.text = value?["todoCategory"] as? String ?? ""
        }
        
    )}


}
