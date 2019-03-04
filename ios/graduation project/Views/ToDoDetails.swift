//
//  ToDoDetails.swift
//  graduation project
//
//  Created by farah on 2/5/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class ToDoDetails: UIViewController ,  UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var showLabel: UILabel!
    var showData = ""
    var showColor : UIColor!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func popupbtn(_ sender: Any) {
        self.performSegue(withIdentifier: "pop" , sender : self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pop" {
            let vc = segue.destination
            vc.preferredContentSize = CGSize(width: 400, height: 400)
            let controller = vc.popoverPresentationController
            
            controller?.delegate = self
            //you could set the following in your storyboard
            controller?.sourceView = self.view
            controller?.sourceRect = CGRect(x: 0, y: 0, width: 100, height: 100)
            controller?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 1)
            
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //return .fullScreen
        //return .popover
        //return .pageSheet
        return .none
        //return .overFullScreen
        
    }
    
    @IBAction func unwindSegue (_sender : UIStoryboardSegue){
        showLabel.text = showData
        showLabel.textColor = showColor
        
    }
    
    
}
