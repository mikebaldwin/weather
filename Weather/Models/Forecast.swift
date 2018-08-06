//
//  Weather.swift
//  Weather
//
//  Created by Michael Baldwin on 7/10/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation

class Forecast: Decodable {
    // daily summary data
    var currentSummary: String
    var currentTemperature: String
    var currentIcon: String
    var currentChanceOfPrecipitation: String
    var currentFeelsLikeTemperature: String
    var currentHumidity: String
    var currentUVIndex: String
    
    // Hourly data
    var todaysSummary: String
    var next12Hours: [Hour]
    
    required init(from decoder: Decoder) throws {
        let rawServerResponse = try RawServerResponse(from: decoder)
        let hourlyData = rawServerResponse.hourly.data
        let desiredHours = 12

        currentSummary = rawServerResponse.currently.summary
        currentTemperature = String(Int(round(rawServerResponse.currently.temperature))) + "º"
        currentIcon = rawServerResponse.currently.icon
        currentChanceOfPrecipitation = String(Int(round(rawServerResponse.currently.chanceOfPrecipitation))) + "%"
        currentFeelsLikeTemperature = String(Int(round(rawServerResponse.currently.feelsLikeTemperature))) + "º"
        currentHumidity = String(rawServerResponse.currently.humidity) + "%"
        currentUVIndex = String(rawServerResponse.currently.uvIndex)
        
        todaysSummary = rawServerResponse.hourly.summary
        next12Hours = Array(hourlyData.dropLast(hourlyData.count - desiredHours))
    }
    
}

fileprivate struct RawServerResponse: Decodable {
    
    var currently: Currently
    var hourly: Hourly
    
    struct Currently: Decodable {
        let summary: String
        let icon: String
        let chanceOfPrecipitation: Double
        let temperature: Double
        let feelsLikeTemperature: Double
        let humidity: Double
        let uvIndex: Int
        
        enum CodingKeys: String, CodingKey {
            case summary
            case icon
            case chanceOfPrecipitation = "precipProbability"
            case temperature
            case feelsLikeTemperature = "apparentTemperature"
            case humidity
            case uvIndex
        }
    }
    
    struct Hourly: Decodable {
        let summary: String
        let icon: String
        let data: [Hour]
    }
    
}
