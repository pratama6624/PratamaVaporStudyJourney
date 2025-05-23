//
//  ErrorController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 05/03/25.
//

import Vapor

struct CustomError: DebuggableError {
    var identifier: String
    var reason: String
}

struct ErrorController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let errorRoutes = routes.grouped("error")
        
        // Throwing an Error
        errorRoutes.get("throwinganerror", use: self.throwingAnError)
            .withMetadata("test throwing an error", "Error Controller")
        
        // Event Loop Future Error
        errorRoutes.get("eventloopfutureerror", use: self.eventLoopFutureError)
            .withMetadata("test event loop future error", "Error Controller")
        
        // Abort for Custom Status Code
        errorRoutes.get("unauthorized", use: self.unauthorized)
            .withMetadata("test abort for custom status code error", "Error Controller")
        
        // Debuggable Error (custom error)
        errorRoutes.get("debuggableerror", use: self.debuggableError)
            .withMetadata("test debuggable error", "Error Controller")
        
        // Error Middleware
        errorRoutes.grouped(CustomErrorMiddleware()).get("errormiddleware", use: self.errorMiddleware)
            .withMetadata("test middleware error", "Error Controller")
        
        // Debuggable Error (custom error)
        errorRoutes.grouped(CustomErrorMiddleware()).get("errormiddlewareadvance", use: self.errorMiddlewareAdvance)
            .withMetadata("test middleware error advance", "Error Controller")
    }
    
    // GET Request -> /error/throwinganerror
    @Sendable
    func throwingAnError(req: Request) throws -> String {
        throw Abort(.internalServerError, reason: "Something went wrong!")
    }
    
    // GET Requset -> /error/eventloopfutureerror
    @Sendable
    func eventLoopFutureError(req: Request) throws -> EventLoopFuture<String> {
        req.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Invalid Request"))
    }
    
    // GET Request -> /error/unauthorized
    @Sendable
    func unauthorized(req: Request) throws -> String {
        throw Abort(.unauthorized, reason: "Unauthorized")
    }
    
    // GET Request -> /error/debuggableerror
    @Sendable
    func debuggableError(req: Request) throws -> String {
        throw CustomError(identifier: "Custom Error", reason: "This is a custom error")
    }
    
    // GET Request -> /error/errormiddleware
    @Sendable
    func errorMiddleware(req: Request) throws -> EventLoopFuture<String> {
        req.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Something went wrong"))
    }
    
    // GET Request -> /error/errormiddlewareadvance
    @Sendable
    func errorMiddlewareAdvance(req: Request) throws -> EventLoopFuture<String> {
        req.eventLoop.makeFailedFuture(ErrorResponse(
            identifier: "CustomError001",
            reason: "Terjadi kesalahan dalam sistem.",
            suggestedFixes: ["Coba periksa kembali input data.", "Restart server jika perlu."]
        ))
    }
}
