//
//  ResetSetting.swift
//  graduation project
//
//  Created by ahmed on 5/4/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

class ResetSetting: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var Email: UITextField!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = .init(red: 30/255, green: 57/255, blue: 83/255, alpha: 1.00)
        self.navigationController?.navigationBar.isTranslucent = false
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        // Do any additional setup after loading the view.
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SendEmailToResetPass(_ sender: Any) {
        
        guard let resetEmail = Email.text else{
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: resetEmail, completion: { (error) in
            //Make sure you execute the following code on the main queue
            DispatchQueue.main.async {
                //Use "if let" to access the error, if it is non-nil
                if let error = error {
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: error.localizedDescription, preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                } else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            }
        })
        
    }
}
