//
//  OpenWeatherController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 10/02/25.
//

import Vapor
import Fluent

struct WeatherController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        // -> /api/openweather?city=jakarta
        routes.get("api", "openweather", use: self.getOpenWeatherByCity)
            .withMetadata("Show from open weather", "Weather Controller")
        
        // -> /api/visualcrossing?city=jakarta
        routes.get("api", "visulcrossing", use: self.getVisualCrossingByCity)
            .withMetadata("Show from visual crossing", "Weather Controller")
    }
    
    // -> GET Request /api/openweather?city=jakarta
    @Sendable
    func getOpenWeatherByCity(req: Request) async throws -> OpenWeatherResponse {
        guard let city: String = req.query["city"] else {
            throw Abort(.badRequest, reason: "City cannot be empty")
        }
        
        let weatherService = OpenWeatherService(client: req.client)
        
        return try await weatherService.getWeatherByCity(for: city)
    }
    
    // -> /api/visualcrossing?city=jakarta
    @Sendable
    func getVisualCrossingByCity(req: Request) async throws -> VisualCrossingResponse {
        guard let city: String = req.query["city"] else {
            throw Abort(.badRequest, reason: "City cannot be empty")
        }
    }
}

