//
//  ApptDetailTVC.swift
//  graduation project
//
//  Created by ahmed on 5/10/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import Firebase

class ApptDetailTVC: UITableViewController {
    
    var ref: DatabaseReference!
    
    var appointment: Appointment?
    var choosedAppointment : String!
    
    var segueEditAppt = "SegueEditAppt"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var apptCostLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var editApptButton: UIButton!
    
    @IBOutlet weak var hideShowEditApptButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noLargeTitles()
        setupUI()
        navBarDropShadow()
        //print(choosedAppointment)
    }
    
    func noLargeTitles(){
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.dragDelegate = self as? UITableViewDragDelegate
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navBarNoShadow()
    }
    
    @IBAction func editAppt(_ sender: UIButton) {
        performSegue(withIdentifier: segueEditAppt, sender: self)
    }
    
    
    
    private var User : User? {
        return Auth.auth().currentUser
    }
    
    func setupUI() {
//        guard let appointment = self.appointment else { return }
//        dateLabel.text = dateFormatter(date: appointment.date)
//        let apptTimeStart = appointment.date
//        let apptTimeEnd = appointment.date + 1800
//        hourLabel.text = "\(hourFormatter(date: apptTimeStart)) - \(hourFormatter(date: apptTimeEnd))"
//
//        if let title = appointment.title {
//            titleLabel.text = "\(title)"
//        }
//        if let cost = appointment.cost {
//            apptCostLabel.text = "\(cost)"
//        }
//        if let note = appointment.note {
//            noteTextView.text = "\(note)"
//        }
        
        
        //fetching appointment from firebase
        guard let apptKey = self.choosedAppointment else {
            return
        }
        print(apptKey)
        
        let userId = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("Events").child(apptKey)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            print(value)
            
            if value?["meventCreator"] as? String == self.User?.email{
                self.hideShowEditApptButton.isHidden = false
            }else{
                self.hideShowEditApptButton.isHidden = true
            }
            
            
            let apptTitle = value?["mtitle"] as? String ?? ""
            self.titleLabel.text = apptTitle
            let apptNote = value?["mdetails"] as? String ?? ""
            self.noteTextView.text = apptNote
            let apptLocation = value?["location"] as? String ?? ""
            self.apptCostLabel.text = apptLocation
            let apptDate = value?["mdate"] as? String ?? ""
            self.dateLabel.text = apptDate
            
            let inFormatter = DateFormatter()
            inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            inFormatter.dateFormat = "HH:mm"
            
            let appointmentTimeStart = value?["mstartTime"] as? String ?? ""
            let startTime = inFormatter.date(from: appointmentTimeStart)!
            let timeInHourFormatter = hourFormatter(date: startTime)
            self.hourLabel.text = timeInHourFormatter
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueEditAppt {
            if let destinationNavigationViewController = segue.destination as? UINavigationController {
                let controller = (destinationNavigationViewController.topViewController as! UpdateApptTVC)
//                controller.appointment = appointment
//                controller.appointmentLoaded = true
                controller.apptKey = choosedAppointment
            }
        }
    }
    
    func navBarDropShadow() {
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.navigationController?.navigationBar.layer.shadowRadius = 4
    }
    
    func navBarNoShadow(){
        self.navigationController?.navigationBar.layer.masksToBounds = true
        self.navigationController?.navigationBar.layer.shadowColor = .none
        self.navigationController?.navigationBar.layer.shadowOpacity = 0
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.navigationController?.navigationBar.layer.shadowRadius = 0
        self.navigationController?.navigationBar.layer.backgroundColor = UIColor.white.cgColor
    }
}
