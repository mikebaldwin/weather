//
//  Hour.swift
//  Weather
//
//  Created by Michael Baldwin on 8/3/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation

struct Hour: Decodable {
    let time: Int
    let summary: String
    let icon: String
    let chanceOfPrecipitation: Double
    let precipitationType: String? // Not included in response if chance of precip is 0.0
    let temperature: Double
    let feelsLikeTemperature: Double
    let humidity: Double
    let uvIndex: Int
    
    enum CodingKeys: String, CodingKey {
        case time
        case summary
        case icon
        case chanceOfPrecipitation = "precipProbability"
        case precipitationType = "preciptype"
        case temperature
        case feelsLikeTemperature = "apparentTemperature"
        case humidity
        case uvIndex
    }
}
