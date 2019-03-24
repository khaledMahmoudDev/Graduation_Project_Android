//
//  E-mail.swift
//  graduation project
//
//  Created by farah on 2/6/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import MessageUI

class E_mail: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var EmailFrom: UITextField!
    
    @IBOutlet weak var EmailTo: UITextField!
    
    
    @IBOutlet weak var Subject: UITextField!
    
    @IBOutlet weak var EmailBody: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    

    @IBAction func SendEmail(_ sender: Any) {
        
        let mailCompose = configureMailCont()
        if MFMailComposeViewController.canSendMail(){
            self.present (mailCompose, animated: true, completion: nil)
        }
        else{
        showMailError()
            
        }
       
    }
    
    func configureMailCont() -> MFMailComposeViewController {
//        guard MFMailComposeViewController.canSendMail() else{
//            return
//        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([EmailTo.text!])
        composer.setSubject(Subject.text!)
        composer.setMessageBody(EmailBody.text, isHTML: false)
        
        present (composer,animated: true)
        return composer
        
        }
    
    
    
    func showMailError () {
        let sendMailErrorAlert = UIAlertController(title: "couldn't send Email", message: "your device couldn't send Email", preferredStyle: .alert)
        let dismiss = UIAlertAction (title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
        
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
        
    }
    }

