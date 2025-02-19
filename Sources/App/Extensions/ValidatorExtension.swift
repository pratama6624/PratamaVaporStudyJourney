//
//  ZipValidatorExtension.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 17/02/25.
//

import Vapor

extension ValidatorResults {
    struct ZipCode {
        let isValid: Bool
    }
    
    struct Password {
        let isValid: Bool
    }
}

// Extension custom validation for zip code
extension ValidatorResults.ZipCode: ValidatorResult {
    var isFailure: Bool { !isValid }
    var successDescription: String? { "Is a valid zip code" }
    var failureDescription: String? { "Is not a valid zip code" }
}

// Extension custom validation for password
extension ValidatorResults.Password: ValidatorResult {
    var isFailure: Bool { !isValid }
    var successDescription: String? { "Password is strong" }
    var failureDescription: String? { "Password must be at least 8 characters long, contain 1 uppercase letter, and 1 number." }
}


