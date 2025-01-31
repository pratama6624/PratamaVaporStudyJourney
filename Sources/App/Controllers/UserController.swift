//
//  UserController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 29/01/25.
//

import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        // This is how Content works
        // Encode -> Object to JSON (Auto)
        // Decode -> JSON to Object (Manual)
        let users = routes.grouped("users", "content")
        
        // Transform from Object to JSON (encode)
        users.get(use: self.index)
            .withMetadata("Content encode", "User Controller")
        
        // Transform from JSON to Object (decode)
        // Transform from Object to JSON (encode)
        users.post(use: self.create)
            .withMetadata("Content decode + encode", "User Controller")
        
        // Transform from Object to JSON (encode)
        users.group(":id") { user in
            user.get(use: self.show)
                .withMetadata("Content encode with id", "User Controller")
        }
        
        // Transform from JSON to Object (decode)
        routes.post("greeting", use: decodeObjectToJSON).withMetadata("Content decode", "User Controller")
        
        // How Content Works With Anonymous Value
        // Jika kita mengirim data JSON kosong {} maka string name di Model Hello akan kosong || nil
        routes.post("hellovaporcontent", use: decodeAnonymousValue)
            .withMetadata("Decode Anonymous value", "User Controller")
        
        // Single Value
        routes.post("welcome", use: self.singleValue)
            .withMetadata("Single value", "User Controller")
        
        // Single Value (pow)
        routes.post("pow", use: self.pow)
            .withMetadata("Single value (pow)", "User Controller")
        
        // Multiple Value with the same name parameter
        routes.post("developer", use: self.developer)
            .withMetadata("Multipe value (same name params)", "User Controller")
        
        // Multiple Value with different name parameter
        routes.post("tags", use: self.tags).withMetadata("Multipe value (different name params)", "User Controller")
    }
    
    // -> GET Request /users/content (Get all users)
    @Sendable
    func index(req: Request) async throws -> [User] {
        return [
            User(id: UUID(), name: " . ", age: 25),
            User(id: UUID(), name: "One", age: 22)
        ]
    }
    
    // -> POST Request /users/content (Add new user)
    @Sendable
    func create(req: Request) async throws -> User {
        // Decode manual
        let user = try req.content.decode(User.self)
        // Encode auto
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
    
    // -> POST Request /greeting
    @Sendable
    func decodeObjectToJSON(req: Request) async throws -> HTTPResponseStatus {
        let greeting = try req.content.decode(Greeting.self)
        
        print(greeting.hello)
        return .ok
    }
    
    // -> POST Request /hellovaporcontent
    @Sendable
    func decodeAnonymousValue(req: Request) async throws -> String {
        let hello = try req.content.decode(Hello.self)
        return "Hello \(hello.name ?? "Anonymous")"
    }
    
    // -> POST /welcome?name=pratama
    @Sendable
    func singleValue(req: Request) async throws -> String {
        let name: String = req.query["name"] ?? "Anonymous"
        return "Welcome \(name)"
    }
    
    // -> POST /pow?number=4
    @Sendable
    func pow(req: Request) async throws -> String {
        // Optional Handling
        guard let number: Int = req.query["number"] else {
            return "Please provide a number"
        }
        
        return "pow of \(number) is \(number * number)"
    }
    
    // -> POST /developer?name=pratama&age=25
    @Sendable
    func developer(req: Request) async throws -> String {
        // Optional Handling
        guard let name: String = req.query["name"] else {
            return "Please provide a name"
        }
        
        guard let age: Int = req.query["age"] else {
            return "Please provide an age"
        }
        
        return "Developer \(name) is \(age) years old"
    }
    
    // -> POST /tags?tag=Swift&tag=Vapor&tag=Fluent
    @Sendable
    func tags(req: Request) async throws -> String {
        let tags: [String] = req.query["tag"] ?? []
        return "Tags: \(tags.joined(separator: ", "))"
    }
}
