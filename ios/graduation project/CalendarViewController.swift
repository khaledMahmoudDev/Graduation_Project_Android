//
//  CalendarViewController.swift
//  graduation project
//
//  Created by ahmed on 5/10/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import JTAppleCalendar
class CalendarViewController: UIViewController {
    
    var ref: DatabaseReference!
    var appointmentsArray = [Appointments]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var cityName: UILabel!
    let client = DarkSkyAPIClient()
    var appointmentsOfTheDay = [Appointment] ()
    
    let formatter = DateFormatter()
    
    private let segueNewApptTVC = "SegueNewApptTVC"
    private let segueApptDetail = "SegueApptDetail"
    
    let persistentContainer = CoreDataStore.instance.persistentContainer
    
    lazy var fetchedResultsController: NSFetchedResultsController<Appointment> = {
        let fetchRequest: NSFetchRequest<Appointment> = Appointment.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        //fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // Calendar Color
    let outsideMonthColor = UIColor.lightGray
    let monthColor = UIColor.darkGray
    let selectedMonthColor = UIColor.white
    let currentDateSelectedViewColor = UIColor.black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        performFetch()
        noLargeTitles()
        setupCalendarView()
        
        calendarView.dropShadowBottom()
        
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates( [Date()] )
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Calendar", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        client.getCurrentWeather(at: Coordinates.Ismailia){ [unowned self] currentWeather, error in
            if let currentWeather = currentWeather {
                let viewModel = CurrentWeatherViewModel(model: currentWeather)
                self.displayWeather(using: viewModel)}
        }
    }
    func displayWeather(using viewModel: CurrentWeatherViewModel) {
        currentTemperatureLabel.text = viewModel.temperature
        currentHumidityLabel.text = viewModel.humidity
        currentPrecipitationLabel.text = viewModel.precipitationProbability
        currentSummaryLabel.text = viewModel.summary
        // currentWeatherIcon.image = viewModel.icon
        cityName.text = "Ismailia , EG"
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
//        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: NSNotification.Name.NSPersistentStoreCoordinatorStoresDidChange, object: nil)
        
        
        //fetch appointment from firebase
        
        
        guard let userId = Auth.auth().currentUser?.uid else{
            return
        }
        ref = Database.database().reference()
        ref.child("Events").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let appointmentTitle = dict["mtitle"] as! String
                let appointmentDetail = dict["mdetails"] as! String
                let appointmentTime = dict["mstartTime"] as! String
                print(appointmentTime)
                let appointmentKey = snapshot.key

                let appointments = Appointments(appTitle: appointmentTitle, appDetails: appointmentDetail, appTime: appointmentTime, appKey : appointmentKey)
                self.appointmentsArray.append(appointments)
                self.tableView.reloadData()
                self.ref.keepSynced(true)
                print("fetched")

            }

        }
        
//        let Events = self.ref.child("Events").child(userId)
//        let query = Events.queryOrdered(byChild: "appointmentDate").queryEqual(toValue: "May 17, 2019")
//        query.observeSingleEvent(of: .value, with: { snapshot in
//            for child in snapshot.children {
//                let childSnap = child as! DataSnapshot
//                let dict = childSnap.value as! [String: Any]
//                let appointmentTitle = dict["appointmentTitle"] as! String
//                let appointmentDetail = dict["appointmentNote"] as! String
//                let appointmentTime = dict["appointmentTime"] as! String
//
//                let appointments = Appointments(appTitle: appointmentTitle, appDetails: appointmentDetail, appTime: appointmentTime)
//                self.appointmentsArray.append(appointments)
//                self.tableView.reloadData()
//                self.ref.keepSynced(true)
//                print("fetched")
//
//            }
//        })
        
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == segueApptDetail {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let appointment = fetchedResultsController.object(at: indexPath)
//                let controller = (segue.destination as! ApptDetailTVC)
//                controller.appointment = appointment
//            }
//        }
        
        if segue.identifier == segueApptDetail{
            if let destination = segue.destination as? ApptDetailTVC{
                if let selectedAppointment = sender as? String{
                    
                    destination.choosedAppointment = selectedAppointment
                }
            }
        }
        
        
    }
    
    @objc func applicationDidEnterBackground(_ notification: Notification) {
        CoreDataStore.instance.save()
    }
    
    
    func noLargeTitles(){
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.dragDelegate = self as? UITableViewDragDelegate
        
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //guard let appointments = fetchedResultsController.fetchedObjects else { return 0 }
        
        return appointmentsArray.count
        //return appointments.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
        
        //let appointment = fetchedResultsController.object(at: indexPath)
        //cell.dateLabel.text = hourFormatter(date: appointment.date)
        
        //cell.noteLabel.text = appointment.note
        //cell.nameLabel.text = appointment.title
        
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        inFormatter.dateFormat = "HH:mm"
        
        let appointmentTime = appointmentsArray[indexPath.row].appointmentTime
        print("hooooo",appointmentTime)
        let date = inFormatter.date(from: appointmentTime)!
        let dateInHourFormatter = hourFormatter(date: date)
        print(dateInHourFormatter)

        cell.dateLabel.text = dateInHourFormatter
        cell.nameLabel.text = appointmentsArray[indexPath.row].appointmentTitle
        cell.noteLabel.text = appointmentsArray[indexPath.row].appointmentDetails
        
        // loadAppointmentsForDate(date: appointment.date)
        return cell
    }
    
    /*  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     let appointment = fetchedResultsController.object(at: indexPath)
     let scell = cell as? AppointmentCell
     
     //   scell?.dateLabel.text = hourFormatter(date: appointment.date)
     // loadAppointmentsForDate(date: appointment.date)
     scell?.noteLabel.text = appointment.note
     scell?.nameLabel.text = appointment.title
     
     }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let choosenAppointment = appointmentsArray[indexPath.row].appointmentKey
        print("apptKey", choosenAppointment)
        performSegue(withIdentifier: segueApptDetail, sender: choosenAppointment)
        //self.appointmentsArray.removeAll()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Appointment
//            let appointment = fetchedResultsController.object(at: indexPath)
//
//            // Delete Appointment
//            persistentContainer.viewContext.delete(appointment)
//            CoreDataStore.instance.save()
            
            ref = Database.database().reference()
            let removeRef = ref.child("Events").child(User!.uid).child(appointmentsArray[indexPath.row].appointmentKey)
            removeRef.removeValue()
            appointmentsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}



//extension CalendarViewController: NSFetchedResultsControllerDelegate {
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch (type) {
//        case .insert:
//            if let indexPath = newIndexPath {
//                print("Appt Added")
//                tableView.insertRows(at: [indexPath], with: .automatic)
//            }
//            break;
//        case .delete:
//            if let indexPath = indexPath {
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//            }
//            break;
//        case .update:
//            if let indexPath = indexPath {
//                print("Appt Changed and updated")
//                tableView.reloadRows(at: [indexPath], with: .automatic)
//            }
//        default:
//            print("...")
//        }
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//
//    }
//
//}

extension CalendarViewController {
    func loadAppointmentsForDate(date: Date){
        
        let dayPredicate = fullDayPredicate(for: date)
        
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            appointmentsOfTheDay = fetchedObjects.filter({ return dayPredicate.evaluate(with: $0) })
            
        }
        
        print("dddddxxxxxx\(appointmentsOfTheDay.count)")
        
        // guard let appointmentsOfTheDay = self.appointmentsOfTheDay else { return }
        
        
        self.appointmentsOfTheDay.map { print("Appointment date is: \(String(describing: $0.date))") }
        guard let gotoObject = appointmentsOfTheDay.first else { return }
        
        print("mmmmmm\(gotoObject.date)")
        guard let indexPath = fetchedResultsController.indexPath(forObject: gotoObject) else { return }
        
        
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        // self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        //  self.tableView.reloadData()
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
    
}



extension CalendarViewController {
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
        
        let todaysDate = Date()
        if todaysDate.day() == cellState.date.day() {
            validCell.dateLabel.textColor = UIColor.purple
        } else {
            validCell.dateLabel.textColor = cellState.isSelected ? UIColor.purple : UIColor.darkGray
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
    }
    
    
    
    func setupViewsFromCalendar(from visibleDates: DateSegmentInfo ) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        
        formatter.dateFormat = "MMMM"
        title = formatter.string(from: date).uppercased()
    }
    
}



extension CalendarViewController: JTAppleCalendarViewDataSource {
    
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


extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let scell = cell as? CalendarDayCell
        scell?.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        //loadAppointmentsForDate(date: date)
        
        return cell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        loadAppointmentsForDate(date: date)
        //calendarViewDateChanged()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsFromCalendar(from: visibleDates)
    }
    
    
    
}
