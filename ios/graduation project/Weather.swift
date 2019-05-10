//
//  Weather.swift
//  Stormy
//
//  Created by Lou Batier on 11/04/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
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
