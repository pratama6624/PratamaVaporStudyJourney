//
//  UserIOBound.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 25/02/25.
//

import Vapor
import Fluent

final class UserIOBound: Model, @unchecked Sendable {
    static let schema: String = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    init() { }
    
    init(id: UUID? = nil, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}
