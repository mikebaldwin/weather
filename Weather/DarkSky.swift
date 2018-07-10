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
    private var weather: Weather?
    
    public func downloadWeather() {
        let finalURL = assembleFinalURL()
        let downloadTask = session.dataTask(with: finalURL) { (data, response, error) in
            self.decodeWeatherData(data)
            self.sendDecodedWeatherToDelegate()
        }
        downloadTask.resume()
    }
    
    private func assembleFinalURL() -> URL {
        let coordinates = Location(latitude: 45.5122, longitude: 122.6587).coordinatesAsString
        return baseURL.appendingPathComponent(coordinates)
    }
    
    private func decodeWeatherData(_ data: Data?) {
        guard let data = data else { return }
        let decoder = JSONDecoder()
        do {
            self.weather = try decoder.decode(Weather.self, from: data)
        } catch {
            print(error)
        }
    }
    
    private func sendDecodedWeatherToDelegate() {
        if let weather = self.weather {
            self.delegate?.darkSkyDidDownload(weather)
        }
    }
}
