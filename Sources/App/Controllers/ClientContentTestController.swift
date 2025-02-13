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
        
        // Httpbin test GET JSON response
        routes.get("httpbin", "test-json", use: testJSon.self)
            .withMetadata("test json response", "Client Content Controller")
    }
    
    // Httpbin test GET
    // -> GET /httpbin/test-get
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
    // -> POST /httpbin/test-post
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
    // -> GET /httpbin/test-basicauth
    @Sendable
    func testBasicAuth(req: Request) async throws -> ClientResponse {
        let response = try await req.client.get("https://httpbin.org/basic-auth/user123/password123") { req in
            let auth = BasicAuthorization(username: "user123", password: "password123")
            req.headers.basicAuthorization = auth
        }
        
        return response
    }
    
    // Httpbin test GET JSON response
    // -> GET /httpbin/test-json
    @Sendable
    func testJSon(req: Request) async throws -> Response {
        let response = try await req.client.get("https://httpbin.org/json")
        let jsonData = response.body.flatMap { Data(buffer: $0) } ?? Data()
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
            throw Abort(.internalServerError, reason: "Invalid JSON response")
        }
        
        return Response(status: .ok, body: .init(data: try JSONSerialization.data(withJSONObject: jsonObject)))
    }
}
