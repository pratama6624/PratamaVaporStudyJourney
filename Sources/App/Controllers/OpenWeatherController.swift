//
//  OpenWeatherController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 10/02/25.
//

import Vapor
import Fluent

struct OpenWeatherController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let weatherGroup = routes.grouped("api", "weather")
        
        // -> /api/weather?city=jakarta
        weatherGroup.get(use: self.getWeatherByCity)
            .withMetadata("Show weather city", "Open Weather Controller")
    }
    
    // -> GET Request /api/weather?city=jakarta
    @Sendable
    func getWeatherByCity(req: Request) async throws -> WeatherResponse {
        guard let city: String = req.query["city"] else {
            throw Abort(.badRequest, reason: "City cannot be empty")
        }
        
        let weatherService = WeatherService(client: req.client)
        
        return try await weatherService.getWeatherByCity(for: city)
    }
}

