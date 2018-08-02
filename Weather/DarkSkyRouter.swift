//
//  DarkSky.swift
//  Weather
//
//  Created by Michael Baldwin on 7/10/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation
import CoreLocation

protocol DarkSkyRouterDelegate: AnyObject {
    func darkSkyDidDownload(_ weather: Weather)
}

class DarkSkyRouter {
    var location: CLLocation?
    
    private let session = URLSession.shared
    private let baseURL = URL(string: "https://api.darksky.net/forecast/2c8e2d3d4cf1360a04149677b746cb17")!
    
    weak var delegate: DarkSkyRouterDelegate?
    private var weather: Weather?
}

// MARK: - Networking
extension DarkSkyRouter {
    
    public func fetchWeather() {
        let finalURL = assembleFinalURL()
        let downloadTask = session.dataTask(with: finalURL) { (data, response, error) in
            guard self.checkFor200(response) == true else { return }
            guard self.decodeWeather(data) == true else { return }
            self.sendDecodedWeatherToDelegate()
        }
        downloadTask.resume()
    }
}

// MARK: - Helper methods
extension DarkSkyRouter {

    private func assembleFinalURL() -> URL {
        if let location = location {
            let coordinates = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
            return baseURL.appendingPathComponent(coordinates)
        }
        // TODO: need a better way to handle a failure to unwrap location
        return baseURL
    }
    
    private func checkFor200(_ response: URLResponse?) -> Bool {
        guard let response = response as? HTTPURLResponse else {
            print("URLResponse could not be cast to HTTPURLResponse")
            return false
        }
        guard response.statusCode == 200 else {
            print("HTTP response was unsuccessful. Status code: \(response.statusCode)")
            return false
        }
        return true
    }
    
    private func decodeWeather(_ data: Data?) -> Bool {
        guard let data = data else {
            print("Unable to unrap data object")
            return false
        }
        do {
            let decoder = JSONDecoder()
            self.weather = try decoder.decode(Weather.self, from: data)
            return true
        } catch {
            print("Unable to decode weather data: \(error.localizedDescription)")
            return false
        }
    }
    
    private func sendDecodedWeatherToDelegate() {
        if let weather = self.weather {
            self.delegate?.darkSkyDidDownload(weather)
        }
    }
}
