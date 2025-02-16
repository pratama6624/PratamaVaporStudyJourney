//
//  ValidationErrorResponse.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/02/25.
//

import Vapor

// Middleware Validation
struct ValidationErrorResponse: Content {
    let errors: [ValidationErrorDetail]
}

struct ValidationErrorDetail: Content {
    let field: String
    let message: String
}
