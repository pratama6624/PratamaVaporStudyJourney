//
//  EventLoopFutureController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 21/02/25.
//

import Vapor

// ELF -> Event Loop Future
struct EventLoopController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        // map test
        routes.get("eventloopfuture", "map", use: mapTest)
            .withMetadata("Test map", "ELF Controller")
        
        // flat map throwing
        routes.get("eventloopfuture", "flatmapthrowingtest", use: flatMapThrowingTest)
            .withMetadata("Test map throwing", "ELF Controller")
        
        // flat map throwing with query params
        routes.get("eventloopfuture", "flatmapthrowingwithquerytest", use: self.flatMapThrowingTestWithQueryParams)
            .withMetadata("Test map throwing with query params", "ELF Controller")
        
        // flat map test -> add 10
        routes.get("eventloopfuture", "flatmap", use: self.flatMapTest)
            .withMetadata("Test flat map", "ELF Controller")
        
        // transform test -> server health check
        routes.get("eventloopfuture", "serverhealthtest", use: self.transformTest)
            .withMetadata("Test transform", "ELF Controller")
        
        // chaining
        routes.get("eventloopfuture", "chaining", use: self.fetchDataTest)
            .withMetadata("Test chaining", "ELF Controller")
    }
    
    // GET Request -> /eventloopfuture/map
    @Sendable
    func mapTest(req: Request) -> EventLoopFuture<String> {
        let eventLoop = req.eventLoop
        let futureText = eventLoop.makeSucceededFuture(("Hello, World!"))
        
        return futureText.map { text in
            return text.uppercased()
        }
    }
    
    // GET Request -> /eventloopfuture/flatmapthrowingtest
    @Sendable
    func flatMapThrowingTest(req: Request) -> EventLoopFuture<String> {
        let eventLoop = req.eventLoop
        let futureNumber = eventLoop.makeSucceededFuture(5)
        
        return futureNumber.flatMapThrowing { number in
            guard number % 2 == 0 else {
                throw Abort(.badRequest, reason: "The number must be even")
            }
            return "Valid number: \(number)"
        }
    }
    
    // GET Request -> /eventloopfuture/flatmapthrowingwithquerytest?number=7
    @Sendable
    func flatMapThrowingTestWithQueryParams(req: Request) -> EventLoopFuture<String> {
        let eventLoop = req.eventLoop
        
        return eventLoop.future().flatMapThrowing {
            guard let numberParams = try? req.query.get(Int.self, at: "number") else {
                throw Abort(.badRequest, reason: "Missing 'number' query parameter")
            }
            
            guard numberParams % 2 == 0 else {
                throw Abort(.badRequest, reason: "Number must be even")
            }
            
            return "Valid number \(numberParams)"
        }
    }
    
    // GET Request -> /eventloopfuture/flatmap
    // Add 10
    @Sendable
    func flatMapTest(req: Request) -> EventLoopFuture<Int> {
        let eventLoop = req.eventLoop
        let futureNumber = eventLoop.makeSucceededFuture(10)
        
        return futureNumber.flatMap { number in
            let newNumber = number + 10
            return eventLoop.makeSucceededFuture(newNumber)
        }
    }
    
    // GET Request -> /eventloopfuture/transform
    // transformTest -> Server health test
    @Sendable
    func transformTest(req: Request) -> EventLoopFuture<String> {
        let eventLoop = req.eventLoop
        
        let serverIsHealthyFuture = eventLoop.future(true)
        
        return serverIsHealthyFuture.transform(to: "Server is OK")
    }
    
    // GET Request -> /eventloopfuture/fetchdata
    @Sendable
    func fetchDataTest(req: Request) -> EventLoopFuture<Response> {
        let client = req.client
        let eventLoop = req.eventLoop
        
        // get from params
        guard let idString = try? req.query.get(String.self, at: "id") else {
            return eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Invalid id"))
        }
        
        // Convert id -> UUID with flat map throwing
        // Chaining
        return eventLoop.future(idString).flatMapThrowing { id in
            guard let uuid = UUID(uuidString: id) else {
                throw Abort(.badRequest, reason: "Invalid id")
            }
            
            return uuid
        }
        .flatMap { uuid in
            let url = "https://reqres.in/api/users/\(uuid.uuidString.prefix(1))"
            return client.get(URI(string: url))
        }
        .flatMapThrowing { response in
            guard let buffer = response.body,
                  let bodyString = buffer.getString(at: 0, length
                                                    : buffer.readableBytes) else {
                throw Abort(.notFound, reason: "Data not found")
            }
            
            var headers = HTTPHeaders()
            headers.add(name: .contentType, value: "appliable/json")
            
            return Response(status: .ok, headers: headers, body: .init(stringLiteral: bodyString))
        }
    }
}
