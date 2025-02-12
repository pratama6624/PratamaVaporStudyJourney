//
//  Untitled.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 12/02/25.
//

import Vapor
import Fluent

struct ClientContentTestController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        // Httpbin test GET
        routes.get("httpbin", "test-get", use: testGet.self)
            .withMetadata("test get", "Client Content Controller")
        
        // Httpbin test POST
        routes.post("httpbin", "test-post", use: testPost.self)
            .withMetadata("test post", "Client Content Controller")
        
        // Httpbin test GET with basic auth
        routes.get("httpbin", "test-basicauth", use: testBasicAuth.self)
            .withMetadata("test basic auth", "Client Content Controller")
    }
    
    // Httpbin test GET
    @Sendable
    func testGet(req: Request) async throws -> ClientResponse {
        let response = try await req.client.get("https://httpbin.org/get") { req in
            try req.query.encode([
                "name": "pratama",
                "age": "25"
            ])
        }
        
        return response
    }
    
    // Httpbin test POST
    @Sendable
    func testPost(req: Request) async throws -> ClientResponse {
        let response = try await req.client.post("https://httpbin.org/post") { req in
            try req.content.encode([
                "name": "pratama",
                "age": "25"
            ])
        }
        
        return response
    }
    
    // Httpbin test GET with basic auth
    @Sendable
    func testBasicAuth(req: Request) async throws -> ClientResponse {
        let response = try await req.client.get("https://httpbin.org/basic-auth/user123/password123") { req in
            let auth = BasicAuthorization(username: "user123", password: "password123")
            req.headers.basicAuthorization = auth
        }
        
        return response
    }
}
