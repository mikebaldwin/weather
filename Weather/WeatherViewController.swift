//
//  ViewController.swift
//  Weather
//
//  Created by Michael Baldwin on 7/9/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    private var weather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let darkSky = DarkSky()
        darkSky.delegate = self
        darkSky.fetchWeather()
    }

    func updateLabelsOnMainQueue() {
        guard let weather = weather else { return }
        DispatchQueue.main.async {
            self.summaryLabel.text = weather.summary
            self.temperatureLabel.text = weather.temperature
        }
    }
}

extension WeatherViewController: DarkSkyDelegate {

    func darkSkyDidDownload(_ weather: Weather) {
        self.weather = weather
        updateLabelsOnMainQueue()
    }
}
