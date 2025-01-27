//
//  Song.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 27/01/25.
//

import Vapor
import Fluent

final class Song: Model, @unchecked Sendable {
    static let schema: String = "songs"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    init() { }
    
    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
