//
//  ActivityTableViewController.swift
//  graduation project
//
//  Created by ahmed on 5/10/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class ActivityTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    var homeAppointmentsArray = [HomeAppointments]()
    var privatAppointment = [HomeAppointments]()
    var publicAppointment = [HomeAppointments]()
    var customAppointment = [HomeAppointments]()
    
    let persistentContainer = CoreDataStore.instance.persistentContainer
    
    lazy var fetchedResultsController: NSFetchedResultsController<Appointment> = {
        let fetchRequest: NSFetchRequest<Appointment> = Appointment.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        
        navBarDropShadow()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        privatAppointment.removeAll()
        publicAppointment.removeAll()
        customAppointment.removeAll()
        tableView.reloadData()
        performFetch()
    }
    
    override func viewWillLayoutSubviews() {
        navBarNoShadow()
    }
    
    private var User : User? {
        return Auth.auth().currentUser
    }
    
    func performFetch() {
//        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
//            
//            do {
//                try self.fetchedResultsController.performFetch()
//                print("Appt Fetch Successful")
//            } catch {
//                let fetchError = error as NSError
//                print("Unable to Perform Fetch Request")
//                print("\(fetchError), \(fetchError.localizedDescription)")
//            }
//        }
        print("date", CalendarViewController.AppointmentDate)
        ref = Database.database().reference()
        ref.child("IOSEvents").queryOrdered(byChild: "mdate").queryEqual(toValue: CalendarViewController.AppointmentDate ).observe(.childAdded){ (snapshot) in
            //print(snapshot)
            if let dict = snapshot.value as? [String : Any]{
                if dict["privacy"] as! String == "private" && dict["meventCreator"] as? String == self.User?.email{
                    let appointmentTitle = dict["mtitle"] as! String
                    let appointmentLocation = dict["location"] as! String
                    let appointmentTime = dict["mstartTime"] as! String
                    let appointmentDate = dict["mdate"] as! String
                    //print(appointmentTime)
                    
                    let appointments = HomeAppointments(appTitle: appointmentTitle, appTime: appointmentTime, appLocation: appointmentLocation, appDate: appointmentDate)
                    self.privatAppointment.append(appointments)
                    self.tableView.reloadData()
                    self.ref.keepSynced(true)
                    print("private")
                    
                }else if  dict["privacy"] as! String == "public"{
                    let appointmentTitle = dict["mtitle"] as! String
                    let appointmentLocation = dict["location"] as! String
                    let appointmentTime = dict["mstartTime"] as! String
                    let appointmentDate = dict["mdate"] as! String
                    //print(appointmentTime)
                    
                    let appointments = HomeAppointments(appTitle: appointmentTitle, appTime: appointmentTime, appLocation: appointmentLocation, appDate: appointmentDate)
                    self.publicAppointment.append(appointments)
                    self.tableView.reloadData()
                    self.ref.keepSynced(true)
                    print("public")
                    
                }else if dict["meventCreator"] as? String != self.User?.email {
                    if dict["privacy"] as! String == "CustomUsers"{
                        let customUsersArray = dict["customUsrs"] as! [String]
                        let checkForCustomUserIsExist = customUsersArray.contains((self.User?.email)!)
                        print(checkForCustomUserIsExist)
                        
                        if checkForCustomUserIsExist == true{
                            let appointmentTitle = dict["mtitle"] as! String
                            let appointmentLocation = dict["location"] as! String
                            let appointmentTime = dict["mstartTime"] as! String
                            let appointmentDate = dict["mdate"] as! String
                            //print(appointmentTime)
                            
                            let appointments = HomeAppointments(appTitle: appointmentTitle, appTime: appointmentTime, appLocation: appointmentLocation, appDate: appointmentDate)
                            self.customAppointment.append(appointments)
                            self.tableView.reloadData()
                            self.ref.keepSynced(true)
                            
                            print("custom")
                        }
                    }
                }else
                    if dict["meventCreator"] as? String == self.User?.email {
                        if dict["privacy"] as! String == "CustomUsers"  {
                            let appointmentTitle = dict["mtitle"] as! String
                            let appointmentLocation = dict["location"] as! String
                            let appointmentTime = dict["mstartTime"] as! String
                            let appointmentDate = dict["mdate"] as! String
                            //print(appointmentTime)
                            
                            let appointments = HomeAppointments(appTitle: appointmentTitle, appTime: appointmentTime, appLocation: appointmentLocation, appDate: appointmentDate)
                            self.customAppointment.append(appointments)
                            self.tableView.reloadData()
                            self.ref.keepSynced(true)
                            
                            print("custom")
                            
                        }
                        
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerTitle : String?
        if section == 0
        {
            headerTitle = "Private Events"
        }
        if section == 1
        {
            headerTitle = "Public Events"
        }
        if section == 2
        {
            headerTitle = "Custom Events"
        }
        return headerTitle
    }
    //    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 50
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        guard let appointments = fetchedResultsController.fetchedObjects else { return 0 }
//        return appointments.count
        
        var sectionIndex : NSInteger=0
        if section == 0
        {
            sectionIndex = privatAppointment.count
        }
        else if section == 1
        {
            sectionIndex = publicAppointment.count
        }
        else if section == 2
        {
            sectionIndex = customAppointment.count
        }
        return sectionIndex
        
        //return homeAppointmentsArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        
        
//        if cell == nil
//        {
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "ActivityCell") as! ActivityCell
//        }
        
//        let appointment = fetchedResultsController.object(at: indexPath)
//        //  cell.timeIntervalLabel.text = dateFormatter(date: appointment.date)
//        let timeAgo:String = timeAgoSinceDate(appointment.dateCreated, currentDate: Date(), numericDates: true)
//        
//        cell.timeIntervalLabel.text = timeAgo
//        cell.activityLabel.text = "New appointment with for \(dateFormatter(date: appointment.date)) at \(hourFormatter(date: appointment.date)) location \(String(describing: appointment.cost))"
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        inFormatter.dateFormat = "HH:mm"
        
        
//        let appointmentPrivate = privatAppointment[indexPath.row].appointmentPrivacy
//        let appointmentCreatorPrivate = privatAppointment[indexPath.row].eventCreator
//
//        let appointmentPublic = publicAppointment[indexPath.row].appointmentPrivacy
        
        
        if indexPath.section == 0 {
//            if appointmentPrivate == "private" && appointmentCreatorPrivate == self.User?.email {
            
                
                let appointmentTime = privatAppointment[indexPath.row].appointmentTime
                let appointmentDate = privatAppointment[indexPath.row].appomtmentDate
                let appointmentLocation = privatAppointment[indexPath.row].appointmentLocation
                let appointmentTitle = privatAppointment[indexPath.row].appointmentTitle
                let date = inFormatter.date(from: appointmentTime)!
                let dateInHourFormatter = hourFormatter(date: date)
                //print(dateInHourFormatter)
                
                //cell.timeIntervalLabel.text = dateInHourFormatter
                
                cell.activityLabel.text = "New appointment \(appointmentTitle) with for \(appointmentDate) at \(dateInHourFormatter) location \(String(describing: appointmentLocation))"
            //}
        }else if indexPath.section == 1{
            //if appointmentPublic == "public"{
                
                let appointmentTime = publicAppointment[indexPath.row].appointmentTime
                let appointmentDate = publicAppointment[indexPath.row].appomtmentDate
                let appointmentLocation = publicAppointment[indexPath.row].appointmentLocation
                let appointmentTitle = publicAppointment[indexPath.row].appointmentTitle
                let date = inFormatter.date(from: appointmentTime)!
                let dateInHourFormatter = hourFormatter(date: date)
                //print(dateInHourFormatter)
                
                //cell.timeIntervalLabel.text = dateInHourFormatter
                
                cell.activityLabel.text = "New appointment \(appointmentTitle) with for \(appointmentDate) at \(dateInHourFormatter) location \(String(describing: appointmentLocation))"
            //}
        }else if indexPath.section == 2{
            let appointmentTime = customAppointment[indexPath.row].appointmentTime
            let appointmentDate = customAppointment[indexPath.row].appomtmentDate
            let appointmentLocation = customAppointment[indexPath.row].appointmentLocation
            let appointmentTitle = customAppointment[indexPath.row].appointmentTitle
            let date = inFormatter.date(from: appointmentTime)!
            let dateInHourFormatter = hourFormatter(date: date)
            //print(dateInHourFormatter)
            
            //cell.timeIntervalLabel.text = dateInHourFormatter
            
            cell.activityLabel.text = "New appointment \(appointmentTitle) with for \(appointmentDate) at \(dateInHourFormatter) location \(String(describing: appointmentLocation))"
        }
        
//        let appointmentTime = homeAppointmentsArray[indexPath.row].appointmentTime
//        let appointmentDate = homeAppointmentsArray[indexPath.row].appomtmentDate
//        let appointmentLocation = homeAppointmentsArray[indexPath.row].appointmentLocation
//        let appointmentTitle = homeAppointmentsArray[indexPath.row].appointmentTitle
//        let date = inFormatter.date(from: appointmentTime)!
//        let dateInHourFormatter = hourFormatter(date: date)
//        //print(dateInHourFormatter)
//
//        //cell.timeIntervalLabel.text = dateInHourFormatter
//
//        cell.activityLabel.text = "New appointment \(appointmentTitle) with for \(appointmentDate) at \(dateInHourFormatter) location \(String(describing: appointmentLocation))"

 
        return cell
    }
    
}

extension ActivityTableViewController {
    
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

extension ActivityTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
}
