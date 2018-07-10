//
//  DarkSky.swift
//  Weather
//
//  Created by Michael Baldwin on 7/10/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation

class DarkSky {
    private let session = URLSession.shared
    private let baseURL = URL(string: "https://api.darksky.net/forecast/2c8e2d3d4cf1360a04149677b746cb17")!
    
    func downloadWeather(onSuccess passWeatherToCaller: @escaping (_ weather: Weather) -> Void) {
        let finalURL = assembleFinalURL()
        let downloadTask = session.dataTask(with: finalURL) { (data, response, error) in
            if let data = data {
                if let weather = self.decodeWeatherData(data) {
                    passWeatherToCaller(weather)
                }
            }
        }
        downloadTask.resume()
    }
    
    private func assembleFinalURL() -> URL {
        let coordinates = Location(latitude: 45.5122, longitude: 122.6587).coordinatesAsString
        return baseURL.appendingPathComponent(coordinates)
    }
    
    private func decodeWeatherData(_ data: Data) -> Weather? {
        let decoder = JSONDecoder()
        do {
            let weather = try decoder.decode(Weather.self, from: data)
            return weather
        } catch {
            print(error)
        }
        return nil
    }
}
