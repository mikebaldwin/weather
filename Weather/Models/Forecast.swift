//
//  Weather.swift
//  Weather
//
//  Created by Michael Baldwin on 7/10/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation

class Forecast: Decodable {
    var currentSummary: String
    var currentTemperature: String
    var todaysSummary: String
    var next12Hours: [Hour]
    
    required init(from decoder: Decoder) throws {
        let rawServerResponse = try RawServerResponse(from: decoder)
        let hourlyData = rawServerResponse.hourly.data
        let desiredHours = 12

        currentSummary = rawServerResponse.currently.summary
        currentTemperature = String(Int(round(rawServerResponse.currently.temperature))) + "º"
        todaysSummary = rawServerResponse.hourly.summary
        next12Hours = Array(hourlyData.dropLast(hourlyData.count - desiredHours))
    }
    
}

fileprivate struct RawServerResponse: Decodable {
    
    var currently: Currently
    var hourly: Hourly
    
    struct Currently: Decodable {
        let summary: String
        let temperature: Double
    }
    
    struct Hourly: Decodable {
        let summary: String
        let icon: String
        let data: [Hour]
    }
    
}
