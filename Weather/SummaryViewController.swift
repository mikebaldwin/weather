//
//  ViewController.swift
//  Weather
//
//  Created by Michael Baldwin on 7/9/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import UIKit
import CoreLocation

class SummaryViewController: UIViewController {

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    private let locationManager = CLLocationManager()
    private var darkSky = DarkSky()
    private var weather: Weather?
    
}

// MARK: - View lifecycle
extension SummaryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
        startReceivingLocationChanges()
        darkSky.delegate = self
    }
}

// MARK: - Private methods
extension SummaryViewController {
    
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
extension SummaryViewController: DarkSkyDelegate {

    func darkSkyDidDownload(_ weather: Weather) {
        self.weather = weather
        updateLabelsOnMainQueue()
    }
}

// MARK: - Location management
extension SummaryViewController: CLLocationManagerDelegate {
    
    func startReceivingLocationChanges() {
        guard verifyUserAuthorizedLocationServices() == true else { return }
        guard verifyLocationServicesEnabled() == true else { return }
        configureLocationServices()
        locationManager.startUpdatingLocation()
    }
    
    private func verifyUserAuthorizedLocationServices() -> Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            print("Location services not authorized")
            return false
        }
        return true
    }
    
    private func verifyLocationServicesEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() == false {
            print("Location services not enabled")
            return false
        }
        return true
    }
    
    private func configureLocationServices() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 1000.0  // In meters.
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation = locations.last!
        darkSky.location = latestLocation
        darkSky.fetchWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
}
