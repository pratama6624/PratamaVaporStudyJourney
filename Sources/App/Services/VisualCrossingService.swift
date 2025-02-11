//
//  VisualCrossingServices.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 11/02/25.
//

import Vapor

struct VisualCrossingService {
    let client: Client
    
    func getVisualCrossingWeatherData(for city: String) async throws -> VisualCrossingResponse {
        let apiKey: String = "M95HDNXPUE5K9R655SKLL3UC2"
        let url: String = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/\(city)/today?unitGroup=metric&include=current&key=\(apiKey)&contentType=json"
        
        let response = try await client.get(URI(string: url))
        
        guard let body = response.body else {
            throw Abort(.badRequest, reason: "Invalid response from Visual Crossing API")
        }
        
        let decodedResponse = try JSONDecoder().decode(VisualCrossingResponse.self, from: body)
        
        return decodedResponse
    }
}
