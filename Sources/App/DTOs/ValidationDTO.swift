//
//  ValidationDTO.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/02/25.
//

import Vapor

struct ValidationDTO: Content, Validatable {
    var name: String
    var age: Int
    var favoriteColor: Color
    
    static func validations(_ validations: inout Vapor.Validations) {
        validations.add("name", as: String.self, is: .count(3...), required: true)
        validations.add("age", as: Int.self, is: .range(18...), required: true)
        validations.add("favoriteColor", as: String.self, is: .in("red", "blue", "green"), required: true)
    }
}

enum Color: String, Codable {
    case red, blue, green
}
