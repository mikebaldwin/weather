//
//  ViewController.swift
//  Weather
//
//  Created by Michael Baldwin on 7/9/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    private let locationManager = CLLocationManager()
    private var darkSky = DarkSky()
    private var weather: Weather?
    
}

// MARK: - View lifecycle
extension WeatherViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
        darkSky.delegate = self
        darkSky.fetchWeather()
    }
}

// MARK: - Private methods
extension WeatherViewController {
    
    private func updateLabelsOnMainQueue() {
        guard let weather = weather else { return }
        DispatchQueue.main.async {
            self.summaryLabel.text = weather.summary
            self.temperatureLabel.text = weather.temperature
        }
    }
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - DarkSkyDelegate
extension WeatherViewController: DarkSkyDelegate {

    func darkSkyDidDownload(_ weather: Weather) {
        self.weather = weather
        updateLabelsOnMainQueue()
    }
}
