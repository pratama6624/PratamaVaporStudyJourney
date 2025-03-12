//
//  UserRelationModel.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 12/03/25.
//

import Vapor
import Fluent

// One to Many ( 1 User can post many posts )
final class UserRelationModel: Model, Content, @unchecked Sendable {
    static let schema: String = "user_relations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Children(for: \.$user)
    var posts: [PostRelationModel]
    
    init() { }
    
    init(di: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
