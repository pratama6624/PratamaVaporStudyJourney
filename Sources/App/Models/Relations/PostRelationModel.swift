//
//  PostRelationModel.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 12/03/25.
//

import Vapor
import Fluent

// Many to One ( Many post for 1 User )
final class PostRelationModel: Model, Content, @unchecked Sendable {
    static let schema: String = "post_relations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @OptionalParent(key: "user_relation_id")
    var user: UserRelationModel?
    
    init() { }
    
    init(id: UUID? = nil, title: String, userID: UUID? = nil) {
        self.id = id
        self.title = title
        if let userID = userID {
            self.$user.id = userID
        }
    }
}
