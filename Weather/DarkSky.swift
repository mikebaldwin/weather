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
}

// MARK: - Networking
extension DarkSky {
    
    public func fetchWeather() {
        let finalURL = assembleFinalURL()
        let downloadTask = session.dataTask(with: finalURL) { (data, response, error) in
            self.validate(response)
            self.decodeWeather(data)
            self.sendDecodedWeatherToDelegate()
        }
        downloadTask.resume()
    }
}

// MARK: - Helper methods
extension DarkSky {

    private func assembleFinalURL() -> URL {
        let coordinates = Location(latitude: 45.5122, longitude: 122.6587).coordinatesAsString
        return baseURL.appendingPathComponent(coordinates)
    }
    
    private func validate(_ response: URLResponse?) {
        guard let response = response as? HTTPURLResponse else {
            print("URLResponse could not be cast to HTTPURLResponse")
            return
        }
        guard response.statusCode == 200 else {
            print("HTTP response was unsuccessful. Status code: \(response.statusCode)")
            return
        }
    }
    
    private func decodeWeather(_ data: Data?) {
        guard let data = data else {
            print("Unable to unrap data object")
            return
        }
        let decoder = JSONDecoder()
        do {
            self.weather = try decoder.decode(Weather.self, from: data)
        } catch {
            print("Unable to decode weather data: \(error.localizedDescription)")
        }
    }
    
    private func sendDecodedWeatherToDelegate() {
        if let weather = self.weather {
            self.delegate?.darkSkyDidDownload(weather)
        }
    }
}
