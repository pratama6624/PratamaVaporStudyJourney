//
//  WeatherService.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 10/02/25.
//

import Vapor

struct OpenWeatherService {
    let client: Client
    let apiKey = "3f791f28c2dbc76d12631dcfe118e1e5"
    
    func getWeatherByCity(for city: String) async throws -> OpenWeatherResponse {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        // Send API Request
        let response = try await client.get(URI(string: url))
        
        // Validation use -> HTTP Status
        if response.status == .ok {
            print("200 OK")
        }
        
        // Validation use -> body request
        guard let body = response.body else {
            throw Abort(.badRequest, reason: "Invalid response from OpenWeather API")
        }
        
        // Decode from Response Body to Object Model / DTO
        let decodedResponse = try JSONDecoder().decode(OpenWeatherResponse.self, from: body)
        
        // Return Final Response
        return decodedResponse
    }
}
