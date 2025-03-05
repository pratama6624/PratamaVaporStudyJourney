//
//  CustomErrorMiddleware.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 05/03/25.
//

import Vapor

final class CustomErrorMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request).flatMapError { error in
            let response: Response
            if let abortError = error as? AbortError {
                response = Response(status: abortError.status)
                try? response.content.encode(["message": abortError.reason])
            } else {
                response = Response(status: .internalServerError)
                try? response.content.encode(["message": "Unexpected server error"])
            }
            return request.eventLoop.makeSucceededFuture(response)
        }
    }
}
