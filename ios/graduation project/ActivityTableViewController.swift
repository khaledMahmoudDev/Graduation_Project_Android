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
        performFetch()
        navBarDropShadow()
    }
    
    override func viewWillLayoutSubviews() {
        navBarNoShadow()
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
        
        guard let userId = Auth.auth().currentUser?.uid else{
            return
        }
        ref = Database.database().reference()
        ref.child("Events").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let appointmentTitle = dict["mtitle"] as! String
                let appointmentTime = dict["mstartTime"] as! String
                let appointmentDate = dict["mdate"] as! String
                let appointmentLocation = dict["location"] as! String
                
                let homeAppointments = HomeAppointments(appTitle : appointmentTitle, appTime : appointmentTime, appLocation : appointmentLocation , appDate : appointmentDate)
                self.homeAppointmentsArray.append(homeAppointments)
                self.tableView.reloadData()
                self.ref.keepSynced(true)
                print("fetched")
                
            }
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        guard let appointments = fetchedResultsController.fetchedObjects else { return 0 }
//        return appointments.count
        
        return homeAppointmentsArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        
//        let appointment = fetchedResultsController.object(at: indexPath)
//        //  cell.timeIntervalLabel.text = dateFormatter(date: appointment.date)
//        let timeAgo:String = timeAgoSinceDate(appointment.dateCreated, currentDate: Date(), numericDates: true)
//        
//        cell.timeIntervalLabel.text = timeAgo
//        cell.activityLabel.text = "New appointment with for \(dateFormatter(date: appointment.date)) at \(hourFormatter(date: appointment.date)) location \(String(describing: appointment.cost))"
        
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        inFormatter.dateFormat = "HH:mm"
        
        let appointmentTime = homeAppointmentsArray[indexPath.row].appointmentTime
        let appointmentDate = homeAppointmentsArray[indexPath.row].appomtmentDate
        let appointmentLocation = homeAppointmentsArray[indexPath.row].appointmentLocation
        let appointmentTitle = homeAppointmentsArray[indexPath.row].appointmentTitle
        let date = inFormatter.date(from: appointmentTime)!
        let dateInHourFormatter = hourFormatter(date: date)
        //print(dateInHourFormatter)
        
        //cell.timeIntervalLabel.text = dateInHourFormatter
        
        cell.activityLabel.text = "New appointment \(appointmentTitle) with for \(appointmentDate) at \(dateInHourFormatter) location \(String(describing: appointmentLocation))"

 
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
