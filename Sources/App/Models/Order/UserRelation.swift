//
//  UserRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 15/03/25.
//

import Vapor
import Fluent

// Batasan studi kasus
/*
    Tidak perlu ditambahkan created_at, updated_at dan deleted_at
    karena hanya untuk test relasi dan hanya cukup id, name dan email saja
 */

final class UserRelation: Model, Content, @unchecked Sendable {
    static let schema: String = "user_multi_relations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    // One to Many
    @Children(for: \.$user)
    var orders: [OrderRelation]
    
    init() { }
    
    init(id: UUID? = nil, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

// DONE
