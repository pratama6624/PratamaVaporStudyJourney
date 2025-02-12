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
        
        // Httpbin test POST
        routes.post("httpbin", "test-post", use: testPost.self)
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
}
