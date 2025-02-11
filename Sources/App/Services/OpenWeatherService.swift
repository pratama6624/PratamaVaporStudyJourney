//
//  WeatherService.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 10/02/25.
//

import Vapor

struct OpenWeatherService {
    let client: Client
    
    func getWeatherByCity(for city: String) async throws -> OpenWeatherResponse {
        let apiKey = "3f791f28c2dbc76d12631dcfe118e1e5"
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        let response = try await client.get(URI(string: url))
        
        guard let body = response.body else {
            throw Abort(.badRequest, reason: "Invalid response from OpenWeather API")
        }
        
        let decodedResponse = try JSONDecoder().decode(OpenWeatherResponse.self, from: body)
        
        return decodedResponse
    }
}
