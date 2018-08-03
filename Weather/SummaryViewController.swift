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
    private var darkSky = DarkSkyRouter()
    private var forecast: Forecast?
    
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

// MARK: - Navigation
extension SummaryViewController {
    
    private enum Segues {
        static let showDetails = "showDetails"
        static let unwindToSummaryViewController = "unwindToSummaryViewController"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.showDetails:
            passHourlyForecastToDetailView(segue)
        default:
            return
        }
    }
    
    private func passHourlyForecastToDetailView(_ segue: UIStoryboardSegue) {
        let navController = segue.destination as! UINavigationController
        let destination = navController.viewControllers.first as! DetailViewController
        if let forecast = forecast {
            destination.next12Hours = forecast.next12Hours
        }
    }

    @IBAction func unwindToSummaryViewController(segue: UIStoryboardSegue) {
        
    }
}

// MARK: - Private methods
extension SummaryViewController {
    
    private func updateLabelsOnMainQueue() {
        guard let forecast = forecast else { return }
        DispatchQueue.main.async {
            self.summaryLabel.text = forecast.currentSummary
            self.temperatureLabel.text = forecast.currentTemperature
        }
    }
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - DarkSkyDelegate
extension SummaryViewController: DarkSkyRouterDelegate {

    func darkSkyDidDownload(_ forecast: Forecast) {
        self.forecast = forecast
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
