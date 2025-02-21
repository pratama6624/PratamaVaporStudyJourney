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
}
