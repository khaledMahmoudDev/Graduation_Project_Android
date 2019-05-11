//
//  DarkSkyAPIClient.swift
//  graduation project
//
//  Created by ahmed on 5/10/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import Foundation

class DarkSkyAPIClient {
    fileprivate let darkSkyApiKey = "8a299abd9d9cc87b9c269b08e6406590"
    
    lazy var baseUrl: URL = {
        return URL(string: "https://api.darksky.net/forecast/\(self.darkSkyApiKey)/")!
    }()
    
    let downloader = JSONDownloader()
    let decoder = JSONDecoder()
    
    typealias WeatherCompletionHandler = (Weather?, DarkSkyError?) -> Void
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, DarkSkyError?) -> Void
    
    private func getWeather(at coordinates: Coordinates, completionHandler completion: @escaping WeatherCompletionHandler) {
        guard let url = URL(string: coordinates.description, relativeTo: baseUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = downloader.jsonTask(with: request) { json, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                guard let weather = Weather(json: json) else {
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                completion(weather, nil)
            }
        }
        
        task.resume()
    }
    
    func getCurrentWeather(at coordinates: Coordinates, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
        getWeather(at: coordinates) { weather, error in
            completion(weather?.currently, error)
        }
    }
}
