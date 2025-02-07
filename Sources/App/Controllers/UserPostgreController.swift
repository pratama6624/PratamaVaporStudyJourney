//
//  UserPostgreController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 07/02/25.
//

import Vapor

struct UserPostgreController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let userpostgre = routes.grouped("userpostgre")
        
        // -> POST Request /userpostgre
        userpostgre.post(use: self.createUser)
    }
    
    // -> POST Request /userpostgre
    @Sendable
    func createUser(req: Request) async throws -> UserPostgreDTO {
        let userpostgre = try req.content.decode(UserPostgre.self)
        
        userpostgre.created_at = Date()
        
        // Save to database
        try await userpostgre.save(on: req.db)
        
        return userpostgre.toUserPostgreeDTO()
    }
}
