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
            .withMetadata("Show all galaxy", "Galaxy Controller")
        
        // POST Request /galaxies
        galaxies.post(use: self.create)
            .withMetadata("Create galaxy", "Galaxy Controller")
    }
    
    // Get All Query
    @Sendable
    func getAll(req: Request) async throws -> [Galaxy] {
        try await Galaxy.query(on: req.db).all()
    }
    
    // Create
    @Sendable
    func create(req: Request) throws -> EventLoopFuture<Galaxy> {
        let galaxy = try req.content.decode(Galaxy.self)
        return galaxy.create(on: req.db)
            .map { galaxy }
    }
}
