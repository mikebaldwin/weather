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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let darkSky = DarkSky()
        darkSky.downloadWeather()
    }

}

