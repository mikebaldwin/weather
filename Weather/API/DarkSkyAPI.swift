//
//  DarkSky.swift
//  Weather
//
//  Created by Michael Baldwin on 7/10/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

protocol DarkSkyAPIDelegate: AnyObject {
    func darkSkyDidDownload(_ forecast: Forecast)
}

class DarkSkyAPI {
    static let shared = DarkSkyAPI()
    var location: CLLocation?
    weak var delegate: DarkSkyAPIDelegate?
    private var forecast: Forecast?    
}

// MARK: - Networking
extension DarkSkyAPI {
    
    func forecast(for location: CLLocation) {
        Alamofire.request(ForecastRouter.getForecast(location)).responseData { (responseData) in
            guard self.decodeForecastJSON(responseData) == true else { return }
            self.sendDecodedWeatherToDelegate()
        }
    }
    
}

// MARK: - Helper methods
extension DarkSkyAPI {

    private func decodeForecastJSON(_ response: DataResponse<Data>) -> Bool {
        guard response.result.error == nil else {
            print(response.result.error!)
            return false
        }
        guard let responseData = response.result.value else {
            print("didn't get any data from the API")
            return false
        }
        do {
            let decoder = JSONDecoder()
            self.forecast = try decoder.decode(Forecast.self, from: responseData)
            return true
        } catch {
            print("Unable to decode forecast data: \(error.localizedDescription)")
            return false
        }
    }
    
    private func sendDecodedWeatherToDelegate() {
        if let forecast = self.forecast {
            self.delegate?.darkSkyDidDownload(forecast)
        }
    }
}
