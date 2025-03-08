//
//  GalaxyController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 08/03/25.
//

import Vapor
import Fluent

struct GalaxyController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let galaxies = routes.grouped("galaxies")
        
        // GET Request /galaxies
        galaxies.get(use: self.getAll)
            .withMetadata("Show all", "Galaxy Controller")
    }
    
    // Get All Query
    @Sendable
    func getAll(req: Request) async throws -> [Galaxy] {
        try await Galaxy.query(on: req.db).all()
    }
}
