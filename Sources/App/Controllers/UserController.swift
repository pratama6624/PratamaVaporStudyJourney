//
//  UserController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 29/01/25.
//

import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users", "content")
        
        users.get(use: self.index)
            .description("User Controller")
            .userInfo["category"] = "How Content Works"
        users.post(use: self.create)
            .description("User Controller")
            .userInfo["category"] = "How Content Works"
        users.group(":id") { user in
            user.get(use: self.show)
                .description("User Controller")
                .userInfo["category"] = "How Content Works"
        }
    }
    
    // -> GET Request /users/content (Get all users)
    @Sendable
    func index(req: Request) async throws -> [User] {
        return [
            User(id: UUID(), name: "Pratama", age: 25),
            User(id: UUID(), name: "One", age: 22)
        ]
    }
    
    // -> POST Request /users/content (Add new user)
    @Sendable
    func create(req: Request) async throws -> User {
        let user = try req.content.decode(User.self)
        return user
    }
    
    // -> GET Request /users/content/:id (Get user detail by ID)
    @Sendable
    func show(req: Request) async throws -> User {
        // Optional Handling
        guard let userID = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        return User(id: userID, name: "Pratama One", age: 25)
    }
}
