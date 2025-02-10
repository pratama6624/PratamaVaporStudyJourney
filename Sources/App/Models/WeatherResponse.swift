//
//  WeatherResponse.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 10/02/25.
//

import Vapor

struct WeatherResponse: Content {
    let name: String
    let main: MainInfo
    let weather: [WeatherInfo]
    
    struct MainInfo: Content {
        let temp: Double
        let humidity: Int
    }
    
    struct WeatherInfo: Content {
        let description: String
    }
}
