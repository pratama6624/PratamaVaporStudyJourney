//
//  UserRelationController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 12/03/25.
//

import Vapor
import Fluent

struct UserRelationController: RouteCollection, @unchecked Sendable {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("userrelations")
        
        users.get(use: self.index)
            .withMetadata("Get all", "User Relations Controller")
        
        users.post(use: self.create)
            .withMetadata("Create", "User Relations Controller")
        
        users.group(":userID") { user in
            user.get(use: self.show)
                .withMetadata("Find by ID", "User Relations Controller")
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [UserRelationModel] {
        try await UserRelationModel.query(on: req.db).with(\.$posts).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> UserRelationModel {
        let user = try req.content.decode(UserRelationModel.self)
        
        try await user.save(on: req.db)
        return user
    }
    
    @Sendable
    func show(req: Request) async throws -> UserRelationModel {
        guard let user = try await UserRelationModel.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound, reason: "Wrong id")
        }
        
        return user
    }
}
