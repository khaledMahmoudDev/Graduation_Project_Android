//
//  NewApptTableViewController.swift
//  graduation project
//
//  Created by ahmed on 5/10/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import JTAppleCalendar
var ylabel : Int = -1
protocol AppointmentTVC {
    
    var selectedTimeSlot: Date? { get set }
    var selectedEndTime : Date? { get set }
    var appointmentsOfTheDay: [Appointment]? { get set }
    
    func confirmAppointment()
    func setupCalendarView()
}



class NewApptTableViewController: UITableViewController, AppointmentTVC , SendSelectedUsers{
    
    
    func setSelectedUsers(selected: Array<String>) {
        self.selectedUsersEmailArray = selected
        //print("noooooooo",selectedUsersEmailArray)
    }
    
   
    static var publicVsPrivate = 0
    
    var selectedUsersEmailArray : Array<String> = []
    
    var ref: DatabaseReference!
    var mDay = ""
    var Mday = ""
    var Mmonth = ""
    var Myear = ""
    //var publicVsPrivate = 0
    var myString = String()
    var selectedTimeSlot: Date?
    var selectedEndTime: Date?
    var appointmentsOfTheDay: [Appointment]?
    let formatter = DateFormatter()
    
    //let segueSelectPatient = "SegueSelectPatientsTVC"
    let persistentContainer = CoreDataStore.instance.persistentContainer
    var calendarViewHidden = true
    var appointmentScrolled = false
    
    // Calendar Color
    let outsideMonthColor = UIColor.lightGray
    let monthColor = UIColor.darkGray
    let selectedMonthColor = UIColor.white
    let currentDateSelectedViewColor = UIColor.black
    
    
    // Load Appointments for given date
    lazy var fetchedResultsController: NSFetchedResultsController<Appointment> = {
        let fetchRequest: NSFetchRequest<Appointment> = Appointment.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        if let selectedDate = calendarView.selectedDates.first {
            fetchRequest.predicate = fullDayPredicate(for: selectedDate)
        }
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    
    @IBOutlet weak var timeSlotLabelEnd: UILabel!
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet weak var timeSlotLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateDetailLabel: UILabel!
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmAppointment(_ sender: UIBarButtonItem) {
        confirmAppointment()
    }
    
    @IBOutlet weak var PublicLabel: UILabel!
    @IBOutlet weak var toggleButton: UISwitch!
    @IBAction func publicVSprivate(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            NewApptTableViewController.publicVsPrivate = 1
            PublicLabel.text = "Public"
            print("on")
        }else
        {
            PublicLabel.text = "Private"
            NewApptTableViewController.publicVsPrivate = 0
            print("off")
        }

        tableView.reloadData()
        
    }
    
    @IBAction func CustomUsers(_ sender: Any) {
        NewApptTableViewController.publicVsPrivate = 2
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        
        fetchAppointmentsForDay()
        noLargeTitles()
        setTextFieldDelegates()
        setTextViewDelegates()
     //   setDoneOnKeyboard()
        noteTextView.placeholder = "Notes"
    //    setupKeyboardNotification()
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates( [Date()] )
        
        tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if selectedTimeSlot != nil {
            timeSlotLabel.text = selectedTimeSlot?.toHourMinuteString()
            ylabel = Calendar.current.component(.hour, from: selectedTimeSlot!)
        }
        if selectedEndTime != nil {
            timeSlotLabelEnd.text = selectedEndTime?.toHourMinuteString()
        }
        if myString != "" {
            
            locationLabel.text = myString
        }
        
        if NewApptTableViewController.publicVsPrivate == 2 {
            
            if selectedUsersEmailArray == [] {
                
                NewApptTableViewController.publicVsPrivate = 1
                self.toggleButton.isOn = true
                self.PublicLabel.text = "Public"
                let alert =  UIAlertController(title: "Custom Users", message: "No custom users were selected, and it will be pulic event unless you change it", preferredStyle: .alert)
                let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                NewApptTableViewController.publicVsPrivate = 2
            }
        }
        
    }
    
    
    
    private var User : User? {
        return Auth.auth().currentUser
    }
    
    
    func confirmAppointment() {
//        let appointment = Appointment(context: persistentContainer.viewContext)
//        //guard let patient = self.patient else { return }
//        guard let selectedTimeSlot = self.selectedTimeSlot else { return }
//        // appointment.patient = patient
//        appointment.date = selectedTimeSlot
//        appointment.note = noteTextView.text
//        appointment.cost = locationLabel.text
//        appointment.title = titleTextField.text
//        appointment.dateCreated = Date()
//
//        CoreDataStore.instance.save()
        
        //saving new appointment to firebase
        
        guard let mstartTime = timeSlotLabel.text ,let mendTime = timeSlotLabelEnd.text ,let mdetails = noteTextView.text, let location = locationLabel.text, let mtitle = titleTextField.text, let mdate = dateDetailLabel.text, let meventCreator = User?.email else{
            return
        }
        
        if NewApptTableViewController.publicVsPrivate == 1 {
            self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
            let values = ["mdate" : mdate, "mstartTime" : mstartTime, "mendTime" : mendTime , "mdetails" : mdetails, "location" : location, "mtitle" : mtitle, "meventCreator" : meventCreator, "privacy" : "public" ]
            self.ref.child("IOSEvents").childByAutoId().setValue(values)
            
            print("Appoinment saved savely in firebase as public")
            
        }else if NewApptTableViewController.publicVsPrivate == 0 {
            self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
            let values = ["mdate" : mdate, "mstartTime" : mstartTime, "mendTime" : mendTime , "mdetails" : mdetails, "location" : location, "mtitle" : mtitle, "meventCreator" : meventCreator, "privacy" : "private"]
            self.ref.child("IOSEvents").childByAutoId().setValue(values)
            
            print("Appoinment saved savely in firebase as private")
            
        }else if NewApptTableViewController.publicVsPrivate == 2{
                self.ref = Database.database().reference(fromURL: "https://ajenda-a702f.firebaseio.com/")
                let values = ["mdate" : mdate, "mstartTime" : mstartTime, "mendTime" : mendTime , "mdetails" : mdetails, "location" : location, "mtitle" : mtitle, "meventCreator" : meventCreator, "privacy" : "CustomUsers" , "customUsrs" : selectedUsersEmailArray] as [String : Any]
                self.ref.child("IOSEvents").childByAutoId().setValue(values)
                print("Appoinment saved savely in firebase as CustomUsers")

            
        }
        
        NewApptTableViewController.publicVsPrivate = 0
        
        dismiss(animated: true, completion: nil)
    }
    
    func noLargeTitles(){
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.dragDelegate = self as? UITableViewDragDelegate
        
    }
    
    func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.NSPersistentStoreCoordinatorStoresWillChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.NSPersistentStoreCoordinatorWillRemoveStore, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 20, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
    }
    
}

extension NewApptTableViewController {
    func toggleCalendarView() {
        calendarViewHidden = !calendarViewHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        appointmentScrolled = true
    }
    
    func updateDateDetailLabel(date: Date){
        formatter.dateFormat = "MMMM dd, yyyy"
        dateDetailLabel.text = formatter.string(from: date)
        mDay = dateDetailLabel.text! ;
      //  print ( " dnt == ", mDay)
//let calanderDate = Calendar.current.dateComponents([.month, .day, .year], from: date)
//         Mday = String( calanderDate.day!)
//         Mmonth = String( calanderDate.month!)
//         Myear = String(calanderDate.year!)
     //   print(Mday,Mmonth,Myear)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            toggleCalendarView()
        }
        
        if (NewApptTableViewController.publicVsPrivate == 1 && toggleButton.isOn == true){
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if calendarViewHidden && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        }
        else if indexPath.row == 6 && toggleButton.isOn == false{
            return 56
        }
        else if indexPath.row == 7{
            if toggleButton.isOn == false{
                return 0.0
            }
            return 56
        }
            
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        return footerView
    }
    
    //  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //    if calendarViewHidden && section == 0 {
    //      return 40
    //    } else {
    //      return 1
    //    }
    //  }
}



extension NewApptTableViewController {
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarDayCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarDayCell else {
            return
        }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func setupCalendarView() {
        // Setup Calendar Spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Setup Labels
        calendarView.visibleDates{ (visibleDates) in
            self.setupViewsFromCalendar(from: visibleDates)
        }
    }
    
    func setupViewsFromCalendar(from visibleDates: DateSegmentInfo ) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        
        formatter.dateFormat = "MMMM dd, yyyy"
        dateDetailLabel.text = formatter.string(from: date)
        
        //calendarView.selectDates( [date] )
        
        updateDateDetailLabel(date: date)
        loadAppointmentsForDate(date: date)
    }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let calendarDate = calendarView.selectedDates.first
        if segue.identifier == "segueTimeSlots" {
            let destinationVC = segue.destination as! TimeSlotsCVC
            destinationVC.appointmentDate = calendarDate
            if let currentAppointments = appointmentsOfTheDay {
                destinationVC.currentAppointments = currentAppointments
            }
        }
        else if segue.identifier == "endInSegue" {
            let destinationVC = segue.destination as! TimeSlots2VC
            destinationVC.appointmentDate = calendarDate
            if let currentAppointments = appointmentsOfTheDay {
                destinationVC.currentAppointments = currentAppointments
            }
            
        }
            
        else if segue.identifier == "segue2" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.string2 = locationLabel.text!
 
        }else if  segue.identifier == "customuser" {
            if let destination = segue.destination as? CustomUsersWithSearch{
                destination.delegate = self
            }
            
        }
    }
    
}


extension NewApptTableViewController {
    func loadAppointmentsForDate(date: Date){
        
        let dayPredicate = fullDayPredicate(for: date)
        
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            appointmentsOfTheDay = fetchedObjects.filter({ return dayPredicate.evaluate(with: $0) })
        }
        
        if appointmentsOfTheDay != nil {
            for appointment in appointmentsOfTheDay! {
                print("Appointment date is: \(String(describing: appointment.date))")
            }
        } else {
            print("Appointment is empty")
        }
    }
    
    func fullDayPredicate(for date: Date) -> NSPredicate {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: date)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dateFrom)
        components.day! += 1
        let dateTo = calendar.date(from: components)
        let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", argumentArray: [dateFrom, dateTo as Any])
        
        return datePredicate
    }
    
    func fetchAppointmentsForDay() {
        do {
            try self.fetchedResultsController.performFetch()
            print("AppointmentForDay Fetch Successful")
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform AppointmentForDay Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
}

extension NewApptTableViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        var parameters: ConfigurationParameters
        var startDate = Date()
        var endDate = Date()
        if let calendarStartDate = formatter.date(from: "2019 01 01"),
            let calendarEndndDate = formatter.date(from: "2019 12 31") {
            startDate = calendarStartDate
            endDate = calendarEndndDate
        }
        parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}


extension NewApptTableViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    // Display Cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        updateDateDetailLabel(date: date)
        loadAppointmentsForDate(date: date)
        
        // calendarViewDateChanged()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        if appointmentScrolled {
            setupViewsFromCalendar(from: visibleDates)
        }
    }
}

extension NewApptTableViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                print("Appt Added")
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            print("Appt Deleted")
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                print("Appt Changed and updated")
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            print("...")
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
}
