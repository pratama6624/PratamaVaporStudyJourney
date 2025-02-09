//
//  UserPostgreController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 07/02/25.
//

import Vapor
import Fluent

struct UserPostgreController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let userpostgre = routes.grouped("userpostgre")
        
        // -> POST Request /userpostgre
        userpostgre.post(use: self.createUser)
            .withMetadata("Create a new user", "User PostgreSQL Controller")
        
        // Search user by username or email
        // -> GET Request /userpostgre?username=prataone
        // -> GET Request /userpostgre?email=pratamaone@example.com
        // -> GET Request /userpostgre?username=pratamaone&email=pratamaone@example.com
        userpostgre.get(use: self.searchUser)
            .withMetadata("Search user", "User PostgreSQL Controller")
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
    
    // Search user by username or email
    @Sendable
    func searchUser(req: Request) async throws -> [UserPostgreDTO] {
        // Decode post data into DTO
        let query = try req.query.decode(UserPostgreDTO.self)
        
        // Search data with DTO value
        let users = try await UserPostgre.query(on: req.db)
            .withDeleted()
            .group(.or) { or in
                // With the exact same username (Without regex)
//                if let username = query.username {
//                    or.filter(\.$username == username)
//                }
                // With the exact same email (Without regex)
//                if let email = query.email {
//                    or.filter(\.$email == email)
//                }
                
                // With REGEX
                if let username = query.username {
                    or.filter(\.$username, .custom("ILIKE"), "%\(username)%")
                }
                if let email = query.email {
                    or.filter(\.$email, .custom("ILIKE"), "%\(email)%")
                }
            }
            .all()
        
        return users.map { $0.toUserPostgreeDTO() }
    }
}
