//
//  ZipCodeValidator.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 18/02/25.
//

import Vapor

private let zipCodeRegex = "^\\d{5}(?:[-\\s]\\d{4})?$"

extension Validator where T == String {
    // Logic for custom validation zip code
    static var zipCode: Validator<T> {
        .init { input in
            guard let range = input.range(of: zipCodeRegex, options: [.regularExpression]), range.lowerBound == input.startIndex && range.upperBound == input.endIndex else {
                    return ValidatorResults.ZipCode(isValid: false)
                }
            return ValidatorResults.ZipCode(isValid: true)
        }
    }
    
    // Logic for custom validation password
    static var password: Validator<T> {
        .init { input in
            let uppercase = input.range(of: "[A-Z]", options: .regularExpression) != nil
            let hasNumber = input.range(of: "\\d", options: .regularExpression) != nil
            let isLongEnough = input.count >= 8
            
            if uppercase && hasNumber && isLongEnough {
                return ValidatorResults.Password(isValid: true)
            } else {
                return ValidatorResults.Password(isValid: false)
            }
        }
    }
}
