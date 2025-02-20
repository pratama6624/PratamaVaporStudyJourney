//
//  AsyncController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 20/02/25.
//

import Vapor

// Handler or Controller
struct AsyncController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.get("users", "async", ":id", use: self.getUserHandler)
            .withMetadata("Get user", "Async Controller")
    }
    
    // handler or Controller using Async Await
    @Sendable
    func getUserHandler(req: Request) async throws -> UserAsync {
        guard let userID = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid user ID")
        }
        
        let user = try await fetchUserFromDatabase(id: userID)
        return user
    }
    
    // handler or Controller using ELF (Event Loop Future)
    func getUserHandlerELF(req: Request) -> EventLoopFuture<UserAsync> {
        guard let userID = req.parameters.get("id", as: UUID.self) else {
            return req.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Invalid user ID"))
        }
        
        return req.eventLoop.makeFutureWithTask {
            try await fetchUserFromDatabase(id: userID)
        }
    }
}

// Model Simulation
struct UserAsync: Content {
    let id: UUID
    let name: String
}

// Database Simulation
func fetchUserFromDatabase(id: UUID) async throws -> UserAsync {
    try await Task.sleep(nanoseconds: 5_000_000_000) // Delay 5 second
    return UserAsync(id: id, name: "Shin Yu-na")
}
