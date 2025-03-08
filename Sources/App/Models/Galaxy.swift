//
//  Galaxy.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 07/03/25.
//

import Vapor
import Fluent

final class Galaxy: Model, Content, @unchecked Sendable {
    static let schema: String = "galaxies"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    // Create empty galaxy
    init() { }
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
