//
//  Weather.swift
//  graduation project
//
//  Created by ahmed on 5/10/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import Foundation

struct Weather {
    let currently: CurrentWeather
}

extension Weather {
    init?(json: [String: AnyObject]) {
        guard let currentWeatherJSON = json["currently"] as? [String: AnyObject], let currentWeather = CurrentWeather(json: currentWeatherJSON) else {
            return nil
        }
        
        self.currently = currentWeather
    }
}
