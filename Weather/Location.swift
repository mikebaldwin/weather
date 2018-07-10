//
//  Location.swift
//  Weather
//
//  Created by Michael Baldwin on 7/10/18.
//  Copyright © 2018 mikebaldwin.co. All rights reserved.
//

import Foundation

struct Location {
    var latitude: Double
    var longitude: Double
    
    var coordinatesAsString: String {
        return String("\(latitude),\(longitude)")
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

}
