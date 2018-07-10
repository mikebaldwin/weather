//
//  Weather.swift
//  Weather
//
//  Created by Michael Baldwin on 7/10/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation

fileprivate class RawServerResponse: Decodable {
    struct Weather: Decodable {
        let currently: Currently
    }
    
    struct Currently: Decodable {
        let summary: String
        let temperature: Double
    }
    
    var currently: Currently
}

struct Weather: Decodable {
    var summary: String
    var temperature: String
    
    init(from decoder: Decoder) throws {
        let rawServerResponse = try RawServerResponse(from: decoder)
        summary = rawServerResponse.currently.summary
        let roundedTemp = Int(round(rawServerResponse.currently.temperature))
        temperature = String(roundedTemp) + "º"
    }
}
