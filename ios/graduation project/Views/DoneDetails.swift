//
//  DoneDetails.swift
//  graduation project
//
//  Created by ahmed on 6/15/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class DoneDetails: UIViewController {

    
    //variables declared just to show data in view will appear
    @IBOutlet weak var DoneTitle: UITextField!
    
    @IBOutlet weak var DoneDetails: UITextView!
    
    @IBAction func OKDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//    override func viewWillAppear(_ animated: Bool) {
//        DoneTitle.text =
//        DoneDetails.text =
//    }

}
