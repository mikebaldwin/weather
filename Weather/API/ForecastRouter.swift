//
//  DarkSkyRouter.swift
//  Weather
//
//  Created by Michael Baldwin on 8/4/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

enum ForecastRouter: URLRequestConvertible {
    static let baseURLString = "https://api.darksky.net"
    static let apiKey = "2c8e2d3d4cf1360a04149677b746cb17"
    
    case getForecast(CLLocation)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getForecast(_):
                return .get
            }
        }
        let url: URL = {
            let relativePath: String
            let coordinates: String
            switch self {
            case .getForecast(let location):
                relativePath = "forecast"
                coordinates = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
            }
            var url = URL(string: ForecastRouter.baseURLString)!
            url.appendPathComponent(relativePath)
            url.appendPathComponent(ForecastRouter.apiKey)
            url.appendPathComponent(coordinates)
            return url
        }()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
}
