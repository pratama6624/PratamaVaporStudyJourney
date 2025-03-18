//
//  UserMultiRelationController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 18/03/25.
//

import Vapor
import Fluent

struct UserMultiRelationController: RouteCollection, @unchecked Sendable {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("user_multi_relations")
        
        users.get(use: self.index)
            .withMetadata("Get all users", "User Multi Relations Controller")
        
        users.post(use: self.create)
            .withMetadata("Create a new user", "User Multi Relations Controller")
        
        users.group(":userID") { user in
            user.get(use: self.show)
                .withMetadata("Show user by id", "User Multi Relations Controller")
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [UserRelation] {
        try await UserRelation.query(on: req.db).with(\.$orders).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> UserRelation {
        let user = try req.content.decode(UserRelation.self)
        
        try await user.save(on: req.db)
        return user
    }
    
    @Sendable
    func show(req: Request) async throws -> UserRelation {
        guard let user = try await
            UserRelation.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound, reason: "Wrong id")
        }
        
        return user
    }
}
