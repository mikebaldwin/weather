//
//  DarkSky.swift
//  Weather
//
//  Created by Michael Baldwin on 7/10/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation

class DarkSky {
    
     func downloadWeather() {
        let session = URLSession.shared
        let baseURL = URL(string: "https://api.darksky.net/forecast/")
        let apiKey = "2c8e2d3d4cf1360a04149677b746cb17"
        let coordinates = ["latitude" : "45.5122", "longitude" : "122.6587"]
        let location = coordinates["latitude"]! + "," + coordinates["longitude"]!

        let finalURL = baseURL?.appendingPathComponent(apiKey).appendingPathComponent(location)
        let downloadTask = session.dataTask(with: finalURL!) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let weather = try decoder.decode(Weather.self, from: data)
                    print(weather)
                } catch {
                    print(error)
                }
            }
        }
        downloadTask.resume()
    }
}
