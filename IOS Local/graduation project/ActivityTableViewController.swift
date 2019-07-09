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
        
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.barTintColor = .init(red: 71/255, green: 130/255, blue: 143/255, alpha: 1.00)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .white
        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0,right: 0)
        
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
    
    
    @IBAction func cancel(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Main") as! MainViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = newViewController
        self.dismiss(animated: true, completion: nil)
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
                    let appointmentKey = snapshot.key
                    
                    let appointments = HomeAppointments(appTitle: appointmentTitle, appTime: appointmentTime, appLocation: appointmentLocation, appDate: appointmentDate, appKey : appointmentKey)
                    self.privatAppointment.append(appointments)
                    self.tableView.reloadData()
                    self.ref.keepSynced(true)
                    print("private")
                    
                }else if  dict["privacy"] as! String == "public"{
                    let appointmentTitle = dict["mtitle"] as! String
                    let appointmentLocation = dict["location"] as! String
                    let appointmentTime = dict["mstartTime"] as! String
                    let appointmentDate = dict["mdate"] as! String
                    let appointmentKey = snapshot.key
                    
                    let appointments = HomeAppointments(appTitle: appointmentTitle, appTime: appointmentTime, appLocation: appointmentLocation, appDate: appointmentDate, appKey : appointmentKey)
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
                            let appointmentKey = snapshot.key
                            
                            let appointments = HomeAppointments(appTitle: appointmentTitle, appTime: appointmentTime, appLocation: appointmentLocation, appDate: appointmentDate, appKey : appointmentKey)
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
                            let appointmentKey = snapshot.key
                            
                            let appointments = HomeAppointments(appTitle: appointmentTitle, appTime: appointmentTime, appLocation: appointmentLocation, appDate: appointmentDate, appKey : appointmentKey)
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
    
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        var myCustomView = UIImageView()
//        var myImage = UIImage(named: "public")!
//        myCustomView.image = myImage
//        
//        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//        header.addSubview(myCustomView)
//        return header
//    }
//        override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return 50
//        }
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell

        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        inFormatter.dateFormat = "HH:mm"
        
        
        if indexPath.section == 0 {
 
            let appointmentTime = privatAppointment[indexPath.row].appointmentTime
            let appointmentDate = privatAppointment[indexPath.row].appomtmentDate
            let appointmentLocation = privatAppointment[indexPath.row].appointmentLocation
            let appointmentTitle = privatAppointment[indexPath.row].appointmentTitle
            let date = inFormatter.date(from: appointmentTime)!
            let dateInHourFormatter = hourFormatter(date: date)
                //print(dateInHourFormatter)
                
                //cell.timeIntervalLabel.text = dateInHourFormatter
            
            let image : UIImage = UIImage(named: "private")!
            cell.cellBackground.image = image
            
            cell.activityLabel.text = "New appointment \(appointmentTitle) with for \(appointmentDate) at \(dateInHourFormatter) location \(String(describing: appointmentLocation))"
            
            
        }else if indexPath.section == 1{
                
            let appointmentTime = publicAppointment[indexPath.row].appointmentTime
            let appointmentDate = publicAppointment[indexPath.row].appomtmentDate
            let appointmentLocation = publicAppointment[indexPath.row].appointmentLocation
            let appointmentTitle = publicAppointment[indexPath.row].appointmentTitle
            let date = inFormatter.date(from: appointmentTime)!
            let dateInHourFormatter = hourFormatter(date: date)
                //print(dateInHourFormatter)
                
                //cell.timeIntervalLabel.text = dateInHourFormatter
            
            let image : UIImage = UIImage(named: "public")!
            cell.cellBackground.image = image
            
            cell.activityLabel.text = "New appointment \(appointmentTitle) with for \(appointmentDate) at \(dateInHourFormatter) location \(String(describing: appointmentLocation))"

        }else if indexPath.section == 2{
            let appointmentTime = customAppointment[indexPath.row].appointmentTime
            let appointmentDate = customAppointment[indexPath.row].appomtmentDate
            let appointmentLocation = customAppointment[indexPath.row].appointmentLocation
            let appointmentTitle = customAppointment[indexPath.row].appointmentTitle
            let date = inFormatter.date(from: appointmentTime)!
            let dateInHourFormatter = hourFormatter(date: date)
            //print(dateInHourFormatter)
            
            //cell.timeIntervalLabel.text = dateInHourFormatter
            let image : UIImage = UIImage(named: "custom")!
            cell.cellBackground.image = image
            
            cell.activityLabel.text = "New appointment \(appointmentTitle) with for \(appointmentDate) at \(dateInHourFormatter) location \(String(describing: appointmentLocation))"
        }

 
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let choosenAppointment = privatAppointment[indexPath.row].appointmentKey
            performSegue(withIdentifier: "checkevent", sender: choosenAppointment)
            self.privatAppointment.removeAll()
            
        }else if indexPath.section == 1{
            
            let choosenAppointment = publicAppointment[indexPath.row].appointmentKey
            performSegue(withIdentifier: "checkevent" , sender: choosenAppointment)
            self.publicAppointment.removeAll()
            
        }else if indexPath.section == 2{
            
            let choosenAppointment = customAppointment[indexPath.row].appointmentKey
            performSegue(withIdentifier: "checkevent" , sender: choosenAppointment)
            self.customAppointment.removeAll()
            
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkevent"{
            if let destination = segue.destination as? ApptDetailTVC{
                if let selectedAppointment = sender as? String{
                    
                    destination.choosedAppointment = selectedAppointment
                    //self.privatAppointment.removeAll()
                }
            }
        }
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
