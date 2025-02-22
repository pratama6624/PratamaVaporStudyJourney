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
            guard let numberParams = try? req.query.get(Int.self, at: "number" ) else {
                throw Abort(.badRequest, reason: "Missing 'number' query parameter")
            }
            
            guard numberParams % 2 == 0 else {
                throw Abort(.badRequest, reason: "Number must be even")
            }
            
            return "Valid number \(numberParams)"
        }
    }
}
