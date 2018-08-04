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
    @IBOutlet weak var locationLabel: UILabel!
    
    private let locationManager = CLLocationManager()
    private var darkSkyRouter = DarkSkyRouter()
    private var forecast: Forecast?
    
}

// MARK: - View lifecycle
extension SummaryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
        startReceivingLocationChanges()
        darkSkyRouter.delegate = self
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
    
    private func updateSummaryLabels() {
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
        updateSummaryLabels()
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
        darkSkyRouter.location = latestLocation
        lookUpCurrentLocation { (placemark) in
            self.locationLabel.text = placemark?.locality ?? ""
        }
        darkSkyRouter.fetchWeather()
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
        guard let lastLocation = self.locationManager.location else {
            completionHandler(nil)
            return
        }
        // Look up the location and pass it to the completion handler
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
            guard error == nil else {
                completionHandler(nil)
                return
            }
            let firstLocation = placemarks?.first
            completionHandler(firstLocation)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
}
