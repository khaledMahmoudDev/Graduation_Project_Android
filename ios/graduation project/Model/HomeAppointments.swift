
//
//  HomeAppointments.swift
//  graduation project
//
//  Created by ahmed on 5/19/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import Foundation
class HomeAppointments{
    
    var appointmentTitle : String
    var appointmentTime : String
    var appomtmentDate : String
    var appointmentLocation : String
    var appointmentKey : String
    
    
    init (appTitle : String, appTime : String, appLocation : String , appDate : String , appKey : String){
        
        appointmentTitle = appTitle
        appointmentTime = appTime
        appointmentLocation = appLocation
        appomtmentDate = appDate
        appointmentKey = appKey

    }
}
