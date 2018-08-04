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

    // MARK: - IBOutlets
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    // MARK: - Instance Variables
    private let locationManager = CLLocationManager()
    private var darkSkyAPI = DarkSkyAPI.shared
    private var forecast: Forecast?
    
}

// MARK: - View lifecycle
extension SummaryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyUserAuthorizedLocationServices()
        configureLocationServices()
        locationManager.startUpdatingLocation()
        darkSkyAPI.delegate = self
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

// MARK: - IBActions
extension SummaryViewController {
    
    @IBAction func refreshLocation(_ sender: Any) {
        locationManager.requestLocation()
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
}

// MARK: - DarkSkyDelegate
extension SummaryViewController: DarkSkyAPIDelegate {

    func darkSkyDidDownload(_ forecast: Forecast) {
        self.forecast = forecast
        updateSummaryLabels()
    }
}

// MARK: - Location management
extension SummaryViewController: CLLocationManagerDelegate {
    
    private func verifyUserAuthorizedLocationServices() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func configureLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 1000.0  // In meters.
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latestLocation = locations.last {
            updateLocationNameLabel(from: latestLocation)
            darkSkyAPI.forecast(for: latestLocation)
        }
    }
    
    func updateLocationNameLabel(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            guard error == nil else {
                return
            }
            let firstLocation = placemarks?.first
            self.locationLabel.text = firstLocation?.locality ?? ""
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
}
