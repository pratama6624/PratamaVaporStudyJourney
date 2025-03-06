//
//  CustomErrorMiddleware.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 05/03/25.
//

import Vapor

struct ErrorResponse: DebuggableError, Content {
    let identifier: String
    let reason: String
    let suggestedFixes: [String]
}

final class CustomErrorMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request).flatMapError { error in
            let response = Response(status: .internalServerError)
            response.headers.replaceOrAdd(name: .contentType, value: "application/json")
            
            if let debuggableError = error as? DebuggableError {
                let errorDetails = ErrorResponse(
                    identifier: debuggableError.identifier,
                    reason: debuggableError.reason,
                    suggestedFixes: debuggableError.suggestedFixes
                )
                do {
                    try response.content.encode(errorDetails, as: .json)
                } catch {
                    try? response.content.encode(["message": "Error encoding response"], as: .json)
                }
            } else {
                try? response.content.encode(["message": "Unexpected server error"], as: .json)
            }
            
            return request.eventLoop.makeSucceededFuture(response)
        }
    }
}
