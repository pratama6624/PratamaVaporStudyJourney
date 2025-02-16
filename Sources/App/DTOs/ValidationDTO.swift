//
//  ValidationDTO.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/02/25.
//

import Vapor

struct ValidationDTO: Content, Validatable {
    let name: String
    let email: String
    let age: Int
    let favoriteColor: Color
    
    static func validations(_ validations: inout Vapor.Validations) {
        validations.add("name", as: String.self, is: .count(3...), required: true)
        // Specific Validation
        validations.add("email", as: String.self, is: .email, required: true)
        validations.add("age", as: Int.self, is: .range(18...), required: true)
        validations.add("favoriteColor", as: String.self, is: .in("red", "blue", "green"), required: true)
    }
}

enum Color: String, Codable {
    case red, blue, green
}
