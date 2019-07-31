//
//  TimeSlotsCVC.swift
//  graduation project
//
//  Created by ahmed on 5/10/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit


class TimeSlots2VC: UICollectionViewController {
    
    private let reuseIdentifier = "TimeSlotCell"
    
    
    var timeSlotter = TimeSlotter()
    var appointmentDate: Date!
    var formatter = DateFormatter()
    var timeSlots = [Date]()
    let currentDate = Date()
    var currentAppointments: [Appointment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(appointmentDate)
       do
       {
        if  ylabel > 0
        {
            do{
            setupTimeSlotter(x: ylabel)
                ylabel = -1
            }
            catch{}
        }
        else if xLabel > 0
            {
            do {
                setupTimeSlotter(x: xLabel)
                xLabel = -1
            }
            catch{}
                
            }
        
        else
        {
            setupTimeSlotter(x: -1)
        }
       }
       catch{}
        
        navBarDropShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navBarNoShadow()
    }
    
    func setupTimeSlotter(x : Int) {
    
        timeSlotter.configureTimeSlotter(openTimeHour: x+1 , openTimeMinutes: 0, closeTimeHour: 24, closeTimeMinutes: 0, appointmentLength: 60, appointmentInterval: 60)
        if let appointmentsArray = currentAppointments {
            timeSlotter.currentAppointments = appointmentsArray.map { $0.date }
        }
        guard let timeSlots = timeSlotter.getTimeSlotsforDate(date: appointmentDate) else {
            print("There is no appointments")
            return }
        
        self.timeSlots = timeSlots
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
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeSlots.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimeSlotCell
        
        if cell.isSelected {
            cell.timeSlotView.backgroundColor = UIColor(hexCode: "#B75AFE")
            cell.timeLabel.textColor = .white
        }
        
        let timeSlot = timeSlots[indexPath.row]
        formatter.dateFormat = "H:mm"
        cell.timeLabel.text = formatter.string(from: timeSlot)
        
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let destinationVC = self.navigationController?.viewControllers[0] as?  NewApptTableViewController {
            destinationVC.selectedEndTime = timeSlots[indexPath.row]
            self.navigationController?.popViewController(animated: true)
        } else if let destinationVC = self.navigationController?.viewControllers[0] as? UpdateApptTVC {
            destinationVC.selectedEndTime = timeSlots[indexPath.row]
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

