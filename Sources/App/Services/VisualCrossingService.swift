//
//  VisualCrossingServices.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 11/02/25.
//

import Vapor

struct VisualCrossingService {
    let client: Client
    let apiKey: String = "M95HDNXPUE5K9R655SKLL3UC2"
    
    func getVisualCrossingWeatherData(for city: String) async throws -> VisualCrossingResponse {
        let url: String = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/\(city)/today?unitGroup=metric&include=current&key=\(apiKey)&contentType=json"
        
        // Send API Request
        let response = try await client.get(URI(string: url))
        
        // Validation use -> HTTP Status
        // Debug response -> JSON Terminal
        if response.status == .ok {
            if let body = response.body {
                let data = Data(buffer: body)
                do {
                    let weatherData = try JSONDecoder().decode(VisualCrossingResponse.self, from: data)
                    dump(weatherData)
                } catch {
                    print("Failed decode JSON: \(error)")
                }
            }
        }
        
        // Validation use -> body request
        guard let body = response.body else {
            throw Abort(.badRequest, reason: "Invalid response from Visual Crossing API")
        }
        
        // Decode from Response Body to Object Model / DTO
        let decodedResponse = try JSONDecoder().decode(VisualCrossingResponse.self, from: body)
        
        // Return Final Response
        return decodedResponse
    }
}
