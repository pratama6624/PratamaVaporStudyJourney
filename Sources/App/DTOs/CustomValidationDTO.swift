//
//  ZipDTO.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 17/02/25.
//

import Vapor

// Custom Validation
let allCompanyEmployees: [String] = [
    "Hwang Yeji",
    "Shin Yuna",
    "Shun Ryujin",
    "Lee Chaeryeong",
    "Choi Jisu"
]

struct CustomValidationDTO: Content, Validatable {
    // For custom validation
    let employeeName: String
    
    let zipCode: String
    let email: String
    let name: String
    let password: String
    
    // Manual
    func validateZipCode() throws {
        let zipCodeRegex = "^\\d{5}(?:[-\\s]\\d{4})?$"

        let zipCode = self.zipCode
        let regexTest = zipCode.range(of: zipCodeRegex, options: .regularExpression)

        if regexTest == nil {
            throw Abort(.badRequest, reason: "Zip code is not valid.")
        }
    }
    
    // This is how to add a validation
    // Automatic way with build-in validation
    static func validations(_ validations: inout Vapor.Validations) {
        // zip code custom validation
        validations.add("zipCode", as: String.self, is: .zipCode)
        // password custom validation
        validations.add("password", as: String.self, is: .password)
        // username custom validation
        validations.add("username", as: String.self, is: .username)
        validations.add("email", as: String.self, is: .email)
        validations.add("name", as: String.self, is: .count(3...))
        
        // Custom validation
        validations.add(
            "employeeName",
            as: String.self,
            is: .custom("Employee is not registered in the company") { employeeName in
                for employee in allCompanyEmployees {
                    if employee == employeeName {
                        return true
                    }
                }
                return false
            }
        )
    }
}
