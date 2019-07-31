//
//  Appointments.swift
//  graduation project
//
//  Created by ahmed on 5/17/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import Foundation
class Appointments{
    var appointmentTitle : String
    var appointmentDetails : String
    var appointmentTime : String
    var appointmentKey : String
    
    init (appTitle : String, appDetails : String, appTime : String, appKey : String) {
        appointmentTitle = appTitle
        appointmentDetails = appDetails
        appointmentTime = appTime
        appointmentKey = appKey
    }
    
    
}
