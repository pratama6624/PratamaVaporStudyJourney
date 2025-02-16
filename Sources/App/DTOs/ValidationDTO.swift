//
//  ValidationDTO.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/02/25.
//

import Vapor

struct ValidationDTO: Content {
    var name: String
    var age: Int
    var favoriteColor: Color
}

enum Color: String, Codable {
    case red, blue, green
}
