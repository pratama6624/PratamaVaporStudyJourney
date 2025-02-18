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
}

extension ValidatorResults.ZipCode: ValidatorResult {
    var isFailure: Bool { !isValid }
    var successDescription: String? { "Is a valid zip code" }
    var failureDescription: String? { "Is not a valid zip code" }
}
