//
//  Hour.swift
//  Weather
//
//  Created by Michael Baldwin on 8/3/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation

class Hour: Decodable {
    var time: String
    var summary: String
    var icon: String
    var chanceOfPrecipitation: String
    var precipitationType: String? // Not included in response if chance of precip is 0.0
    var temperature: String
    var feelsLikeTemperature: String
    var humidity: String
    var uvIndex: String
    
    required init(from decoder: Decoder) throws {
        let rawServerResponse = try RawServerResponse(from: decoder)
        time = Hour.formattedHourFrom(rawServerResponse.time)
        summary = rawServerResponse.summary
        icon = rawServerResponse.icon
        chanceOfPrecipitation = String(Int(round(rawServerResponse.chanceOfPrecipitation))) + "%"
        precipitationType = rawServerResponse.precipitationType ?? nil
        temperature = String(Int(round(rawServerResponse.temperature))) + "º"
        feelsLikeTemperature = String(Int(round(rawServerResponse.feelsLikeTemperature))) + "º"
        humidity = String(Int(round(rawServerResponse.humidity))) + "%"
        uvIndex = String(rawServerResponse.uvIndex)
    }
    
    private static func formattedHourFrom(_ timeStamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timeStamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: date)
    }
}

fileprivate struct RawServerResponse: Decodable {
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
