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
    
    enum BackendError: Error {
        case apiError(reason: Error)
        case decodingError(reason: Error)
        case invalidResponseData
    }
}

// MARK: - Networking
extension DarkSkyAPI {
    
    func forecast(for location: CLLocation) {
        Alamofire.request(ForecastRouter.getForecast(location)).responseData { (responseData) in
            if let forecast = try? self.decodeForecastJSON(responseData) {
                self.delegate?.darkSkyDidDownload(forecast)
            }
        }
    }
    
}

// MARK: - Helper methods
extension DarkSkyAPI {

    private func decodeForecastJSON(_ response: DataResponse<Data>) throws -> Forecast {
        guard response.result.error == nil else {
            throw BackendError.apiError(reason: response.result.error!)
        }
        guard let responseData = response.result.value else {
            throw BackendError.invalidResponseData
        }
        do {
            let decoder = JSONDecoder()
            let forecast = try decoder.decode(Forecast.self, from: responseData)
            return forecast
        } catch {
            throw BackendError.decodingError(reason: error)
        }
    }
}
