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
    
    // Validator List :
    /*
        - .count(min...) -> Panjang minimal string, array, atau collection
        - .count(...max) -> Panjang maksimal string, array, collection
        - .count(min...max) -> Rentang
        - .alphanumeric -> String ( huruf & angka )
        - .email -> String format for email
        - .url -> String format for url
        - .uuid -> String format for uuid
        - .ascii -> String ASCII character
        - .numeric -> String format for number
        - .in(options...) -> Member of something ( enum, array, & more )
        - .range(min...) -> Angka minimal
        - .range(...max) -> Angka maksimal
        - .range(min...max) -> Angka rentang
        - .contains(substring) -> Sub string
        - .begins(with:) -> String begin
        - .ends(with:) -> String end
        - .regex(pattern:) -> Pola regex
     */
    
    // This is how to add a validation
    static func validations(_ validations: inout Vapor.Validations) {
        // String Validation
        validations.add("name", as: String.self, is: .count(3...), required: true)
        // String Validation
        // Specific Validation
        validations.add("email", as: String.self, is: .email, required: true)
        // Integer Validation
        validations.add("age", as: Int.self, is: .range(18...), required: true)
        // Enum Validation
        validations.add("favoriteColor", as: String.self, is: .in("red", "blue", "green"), required: true)
    }
}

enum Color: String, Codable {
    case red, blue, green
}
