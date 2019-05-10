//
//  Coordinates.swift
//  Stormy
//
//  Created by Lou Batier on 11/04/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

extension Coordinates: CustomStringConvertible {
    var description: String {
        return "\(latitude),\(longitude)"
    }
    
    static var Ismailia: Coordinates {
        return Coordinates(latitude: 30.6, longitude: 32.27)
    }
}
