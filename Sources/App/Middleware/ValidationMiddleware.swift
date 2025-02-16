//
//  ValidationMiddleware.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/02/25.
//

import Vapor

final class ValidationMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request).flatMapError { error in
            if let validationError = error as? ValidationsError {
                let errors = validationError.failures.map { failure in
                    ValidationErrorDetail(field: failure.key.stringValue, message: failure.failureDescription ?? "Invalid Value")
                }
                
                let response = Response(status: .badRequest)
                
                do {
                    try response.content.encode(ValidationErrorResponse(errors: errors))
                } catch {
                    return request.eventLoop.makeFailedFuture(error)
                }
                
                return request.eventLoop.makeSucceededFuture(response)
            }
            
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}
