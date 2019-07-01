

import UIKit
import CoreData
import Firebase
import JTAppleCalendar




class UpdateApptTVC: UITableViewController, AppointmentTVC , SendEditedSelectedUsers {
    
    
    
    func setEditedSelectedUsers(selected: Array<String>) {
        self.selectedUsersEmailArray = selected
        //print("noooooooo",selectedUsersEmailArray)
    }
    
    
    var selectedEndTime: Date?
    var apptKey : String!
    var ref: DatabaseReference!
    var selectedTimeSlot: Date?
    var appointmentsOfTheDay: [Appointment]?
    var myString = String()
    var appointment: Appointment?
    let formatter = DateFormatter()
    var appointmentLoaded: Bool!
    var appointmentScrolled = false
    var calendarViewHidden = true
    static var publicVsPrivate = 0
    var selectedUsersEmailArray : Array<String> = []
    var customUserArray : Array<String> = []

    
    // let segueSelectPatient = "SegueSelectPatientsTVC"
    
    let persistentContainer = CoreDataStore.instance.persistentContainer
    
    // Calendar Color
    let outsideMonthColor = UIColor.lightGray
    let monthColor = UIColor.darkGray
    let selectedMonthColor = UIColor.white
    let currentDateSelectedViewColor = UIColor.black
    
    
    // Load Appointments for selected Date in Calendar
    lazy var fetchedResultsController: NSFetchedResultsController<Appointment> = {
        let fetchRequest: NSFetchRequest<Appointment> = Appointment.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        if let selectedDate = calendarView.selectedDates.first {
            fetchRequest.predicate = fullDayPredicate(for: selectedDate )
        }
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    //  @IBOutlet var calendarDateLabel: UILabel!
    //  @IBOutlet var yearLabel: UILabel!
    
    @IBOutlet weak var timeSlotLabel: UILabel!
    
    @IBOutlet weak var updatedEndTime: UILabel!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noLargeTitles()
        setupCalendarView()
        fetchAppointmentsForDay()
        setupKeyboardNotification()
        setTextFieldDelegates()
        setTextViewDelegates()
        setDoneOnKeyboard()
        loadAppointment()
        print("..........",apptKey)
        
        calendarView.visibleDates{ (visibleDates) in
            self.setupViewsFromCalendar(from: visibleDates)
        }
    }
    
    
    @IBOutlet weak var PublicLabel: UILabel!
    @IBOutlet weak var toggleButton: UISwitch!
    @IBAction func publicVSprivate(_ sender: Any) {
        if (sender as AnyObject).isOn == true {
            UpdateApptTVC.publicVsPrivate = 1
            PublicLabel.text = "Public"
            print("on")
        }else
        {
            PublicLabel.text = "Private"
            UpdateApptTVC.publicVsPrivate = 0
            print("off")
        }
        
    }
    
    
    @IBAction func editCustomUsers(_ sender: Any) {
        UpdateApptTVC.publicVsPrivate = 2
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if selectedTimeSlot != nil {
            timeSlotLabel.text = selectedTimeSlot?.toHourMinuteString()
            xLabel = Calendar.current.component(.hour, from: selectedTimeSlot!)
        }
        if selectedEndTime != nil
        {
            updatedEndTime.text = selectedEndTime?.toHourMinuteString()
        }
        if myString != "" {

            locationLabel.text = myString
        }
        
        
    }
    
    func loadAppointment() {
        
//        guard let appointment = self.appointment else { return }
//        calendarView.scrollToDate(appointment.date, animateScroll: false)
//        calendarView.selectDates( [appointment.date] )
//
//
//
//        timeSlotLabel.text = hourFormatter(date: appointment.date)
//        if let title = appointment.title {
//            titleTextField.text = title
//        }
//        if let cost = appointment.cost {
//            locationLabel.text = cost
//        }
//        if let note = appointment.note {
//            noteTextView.text = note
//        }
//        print("Appointment date: \(String(describing: appointment.date))")
        
        
        //fetch appointment from firebase to be edited
        
        guard let apptKey = self.apptKey else {
            return
        }
        print(apptKey)
        
        let userId = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("IOSEvents").child(apptKey)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let apptTitle = value?["mtitle"] as? String ?? ""
            self.titleTextField.text = apptTitle
            let apptNote = value?["mdetails"] as? String ?? ""
            self.noteTextView.text = apptNote
            let apptLocation = value?["location"] as? String ?? ""
            self.locationLabel.text = apptLocation
            let apptDate = value?["mdate"] as? String ?? ""
            self.dateDetailLabel.text = apptDate

            let appointmentStartTime = value?["mstartTime"] as? String ?? ""
            self.timeSlotLabel.text = appointmentStartTime
            let appointmentEndTime = value?["mendTime"] as? String ?? ""
            self.updatedEndTime.text = appointmentEndTime
            let apptPrivacy = value?["privacy"] as? String ?? ""
            self.toggleButton.isSelected = !self.toggleButton.isSelected
            print(apptPrivacy)
            if apptPrivacy == "public"{
                UpdateApptTVC.publicVsPrivate = 1
                self.toggleButton.isOn = true
                self.PublicLabel.text = "Public"
            }else if apptPrivacy == "private"{
                UpdateApptTVC.publicVsPrivate = 0
                self.toggleButton.isOn = false
                self.PublicLabel.text = "Private"
                //self.publicVSprivate(false)
            }else if apptPrivacy == "CustomUsers"{
                UpdateApptTVC.publicVsPrivate = 2
                self.customUserArray = (value?["customUsrs"] as? [String])!
//                print("custom", self.customUserArray)

            }
            
            print("custom", self.customUserArray)
            

            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    private var User : User? {
        return Auth.auth().currentUser
    }
    
    
    
    func confirmAppointment() {
        //  guard let appointment = appointment else { return }
        
        //guard let selectedTimeSlot = self.selectedTimeSlot else { return }
//        if selectedTimeSlot != nil {
//            appointment?.date = selectedTimeSlot!
//        }
//        appointment?.dateModified = Date()
//
//        if noteTextView.text != nil {
//            appointment?.note = noteTextView.text
//        }
//        if locationLabel.text != nil {
//            appointment?.cost = locationLabel.text
//        }
//        if titleTextField.text != nil {
//            appointment?.title = titleTextField.text
//        }
//
//        CoreDataStore.instance.save()
        
        //updating appointment in firebase
        
        guard let mstartTime = timeSlotLabel.text ,let mendTime = updatedEndTime.text ,let mdetails = noteTextView.text, let location = locationLabel.text, let mtitle = titleTextField.text, let mdate = dateDetailLabel.text, let meventCreator = User?.email else{return}
        
        
        
        
        if UpdateApptTVC.publicVsPrivate == 1 {
            ref = Database.database().reference().child("IOSEvents").child(apptKey)
            let values = ["mdate" : mdate, "mstartTime" : mstartTime, "mendTime" : mendTime , "mdetails" : mdetails, "location" : location, "mtitle" : mtitle, "meventCreator" : meventCreator, "privacy" : "public" ]
            self.ref.updateChildValues(values)
            
            print("updated as public")
            
        }else if UpdateApptTVC.publicVsPrivate == 0 {
            ref = Database.database().reference().child("IOSEvents").child(apptKey)
            let values = ["mdate" : mdate, "mstartTime" : mstartTime, "mendTime" : mendTime , "mdetails" : mdetails, "location" : location, "mtitle" : mtitle, "meventCreator" : meventCreator, "privacy" : "private" ]
            self.ref.updateChildValues(values)
            
            print("updated as private")
            
        }else if UpdateApptTVC.publicVsPrivate == 2{
            //print ("here", selectedUsersEmailArray)
            ref = Database.database().reference().child("IOSEvents").child(apptKey)
            let values = ["mdate" : mdate, "mstartTime" : mstartTime, "mendTime" : mendTime , "mdetails" : mdetails, "location" : location, "mtitle" : mtitle, "meventCreator" : meventCreator, "privacy" : "CustomUsers" , "customUsrs" : selectedUsersEmailArray] as [String : Any]
            self.ref.updateChildValues(values)
            print("updated as CustomUsers")
        }
        
        UpdateApptTVC.publicVsPrivate = 0
        
        
        
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

extension UpdateApptTVC {
    func toggleCalendarView() {
        calendarViewHidden = !calendarViewHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        appointmentScrolled = true
    }
    
    func updateDateDetailLabel(date: Date){
        formatter.dateFormat = "MMMM dd, yyyy"
        dateDetailLabel.text = formatter.string(from: date)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            toggleCalendarView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if calendarViewHidden && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}


extension UpdateApptTVC {
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
        
        calendarView.selectDates( [date] )
        
        updateDateDetailLabel(date: date)
        loadAppointmentsForDate(date: date)
        
    }
    
    /* func calendarViewDateChanged() {
     guard let calendarDate = calendarView.selectedDates.first else { return }
     dateDetailLabel.text = DateFormatter.localizedString(from: calendarDate, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let calendarDate = calendarView.selectedDates.first
        if segue.identifier == "segueTimeSlotsFromUpdate" {
            let destinationVC = segue.destination as! TimeSlotsCVC
            destinationVC.appointmentDate = calendarDate
            if let currentAppointments = appointmentsOfTheDay {
                destinationVC.currentAppointments = currentAppointments
            }
        }
        else if segue.identifier == "updateEndSegue" {
            let destinationVC = segue.destination as! TimeSlots2VC
            destinationVC.appointmentDate = calendarDate
            if let currentAppointments = appointmentsOfTheDay {
                destinationVC.currentAppointments = currentAppointments
            }
            
            
        }
        else if segue.identifier == "segue3" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.string2 = locationLabel.text!
            
            
            
        }
        else if  segue.identifier == "editcustomusers" {
            if let destination = segue.destination as? EditCustomUsersWithSearch{
                destination.fetchedArrayFromFireBase = customUserArray
                destination.delegate = self 
            }
            
        }
    }
}


extension UpdateApptTVC: JTAppleCalendarViewDataSource {
    
    
    
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


extension UpdateApptTVC: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    
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
        //    calendarViewDateChanged()
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


extension UpdateApptTVC: NSFetchedResultsControllerDelegate {
    
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


