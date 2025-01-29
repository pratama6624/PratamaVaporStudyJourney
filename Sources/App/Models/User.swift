//
//  User.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 29/01/25.
//

import Vapor

// Smaple -> How Content Works
struct User: Content {
    var id: UUID?
    var name: String
    var age: Int
}
