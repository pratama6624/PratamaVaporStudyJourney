//
//  ZipValidatorExtension.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 17/02/25.
//

import Vapor

extension ValidatorResults {
    // Custom validation Zip Code
    struct ZipCode {
        let isValid: Bool
    }
    
    // Custom validation Password
    struct Password {
        let isValid: Bool
    }
    
    // Custom validation Username
    struct Username {
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

// Extension custom validation for password
extension ValidatorResults.Username: ValidatorResult {
    var isFailure: Bool { !isValid }
    var successDescription: String? { "Username is valid" }
    var failureDescription: String? { "Username must be 5-15 characters, only letters, numbers, and underscores (_), and cannot start or end with _." }
}
