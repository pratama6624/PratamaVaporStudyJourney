//
//  HTMLExtension.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 10/02/25.
//

import Vapor

// HTML extension -> encodeResponse
extension HTML: AsyncResponseEncodable {
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
