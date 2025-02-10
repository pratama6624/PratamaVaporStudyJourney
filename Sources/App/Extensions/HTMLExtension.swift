//
//  HTMLExtension.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 10/02/25.
//

import Vapor

// HTML extension -> encodeResponse
// Async
extension HtmlDTO: AsyncResponseEncodable {
    public func encodeResponse(for request: Request) async throws -> Response {
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "text/html")
        
        return Response(
            status: .ok,
            headers: headers,
            body: .init(string: value)
        )
    }
}


// EventLoopFuture -> It is no longer used in Swift vesrion 4 & above
