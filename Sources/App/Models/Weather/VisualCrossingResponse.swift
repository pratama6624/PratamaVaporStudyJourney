//
//  VisualCrossingResponse.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 11/02/25.
//

import Vapor

struct VisualCrossingResponse: Content {
    let queryCost: Int
    let latitude, longitude: Double
    let resolvedAddress, address, timezone: String
    let tzoffset: Int
    let days: [WeatherDay]
    let stations: [String: WeatherStation]?
    let currentConditions: CurrentConditions
    
    // MARK: - Weather Day Data
    struct WeatherDay: Content {
        let datetime: String
        let datetimeEpoch: Int
        let tempmax, tempmin, temp: Double
        let feelslikemax, feelslikemin, feelslike: Double
        let dew, humidity, precip, precipprob: Double
        let precipcover: Double?
        let preciptype: [String]?
        let snow, snowdepth: Double
        let windgust, windspeed, winddir: Double?
        let pressure, cloudcover, visibility, solarradiation, solarenergy: Double
        let uvindex, severerisk: Int
        let sunrise, sunset: String
        let sunriseEpoch, sunsetEpoch: Int
        let moonphase: Double
        let conditions, description, icon: String
        let stations: [String]?
        let source: String
    }

    // MARK: - Current Weather Conditions
    struct CurrentConditions: Content {
        let datetime: String
        let datetimeEpoch: Int
        let temp, feelslike, humidity, dew: Double
        let precip: Double?
        let precipprob, snow, snowdepth: Double
        let preciptype: [String]?
        let windgust, windspeed, winddir: Double?
        let pressure, visibility, cloudcover, solarradiation, solarenergy: Double
        let uvindex: Int
        let conditions, icon: String
        let stations: [String]?
        let source, sunrise, sunset: String
        let sunriseEpoch, sunsetEpoch: Int
        let moonphase: Double
    }

    // MARK: - Weather Station Info
    struct WeatherStation: Content {
        let distance, latitude, longitude: Double
        let useCount: Int
        let id, name: String
        let quality, contribution: Int
    }
}
