//
//  DarkSky.swift
//  Weather
//
//  Created by Michael Baldwin on 7/10/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation

protocol DarkSkyDelegate: AnyObject {
    func darkSkyDidDownload(_ weather: Weather)
}

class DarkSky {
    private let session = URLSession.shared
    private let baseURL = URL(string: "https://api.darksky.net/forecast/2c8e2d3d4cf1360a04149677b746cb17")!
    
    weak var delegate: DarkSkyDelegate?
    
    func downloadWeather() {
        let finalURL = assembleFinalURL()
        let downloadTask = session.dataTask(with: finalURL) { (data, response, error) in
            guard let data = data else { return }
            guard let weather = self.decodeWeatherData(data) else { return }
            self.delegate?.darkSkyDidDownload(weather)
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
