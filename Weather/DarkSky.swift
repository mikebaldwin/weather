//
//  DarkSky.swift
//  Weather
//
//  Created by Michael Baldwin on 7/10/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation

class DarkSky {
    
    func downloadWeather(onSuccess passWeatherToCaller: @escaping (_ weather: Weather) -> Void) {
        let session = URLSession.shared
        let baseURL = URL(string: "https://api.darksky.net/forecast/")
        let apiKey = "2c8e2d3d4cf1360a04149677b746cb17"
        let coordinates = Location(latitude: 45.5122, longitude: 122.6587).coordinatesAsString
        let finalURL = baseURL?.appendingPathComponent(apiKey).appendingPathComponent(coordinates)
        let downloadTask = session.dataTask(with: finalURL!) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let weather = try decoder.decode(Weather.self, from: data)
                    passWeatherToCaller(weather)
                } catch {
                    print(error)
                }
            }
        }
        downloadTask.resume()
    }
}
