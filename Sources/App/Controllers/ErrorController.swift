//
//  ErrorController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 05/03/25.
//

import Vapor

struct ErrorController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let errorRoutes = routes.grouped("error")
        
        // Throwing an Error
        errorRoutes.get("throwinganerror", use: self.throwingAnError)
            .withMetadata("test throwing an error", "Error Controller")
    }
    
    // GET Request -> /error/throwinganerror
    @Sendable
    func throwingAnError(req: Request) throws -> String {
        throw Abort(.internalServerError, reason: "Something went wrong!")
    }
}
