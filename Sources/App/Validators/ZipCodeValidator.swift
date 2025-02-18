//
//  ZipCodeValidator.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 18/02/25.
//

import Vapor

private let zipCodeRegex = "^\\d{5}(?:[-\\s]\\d{4})?$"

extension Validator where T == String {
    static var zipCode: Validator<T> {
        .init { input in
            guard let range = input.range(of: zipCodeRegex, options: [.regularExpression]), range.lowerBound == input.startIndex && range.upperBound == input.endIndex else {
                    return ValidatorResults.ZipCode(isValid: false)
                }
            return ValidatorResults.ZipCode(isValid: true)
        }
    }
}
