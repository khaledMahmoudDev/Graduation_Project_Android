//
//  Coordinates.swift
//  graduation project
//
//  Created by ahmed on 5/10/19.
//  Copyright © 2019 Ajenda. All rights reserved.
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
