//
//  UserPostgre.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 06/02/25.
//

import Vapor
import Fluent

final class UserPostgre: Model, Content, @unchecked Sendable {
    static let schema: String = "userpostgres"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "contact")
    var contact: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "role")
    var role: String
    
    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var delete_at: Date?
    
    init() { }
    
    init(id: UUID? = nil, username: String, email: String, contact: String, password: String, image: String, role: String, created_at: Date = Date(), updated_at: Date = Date(), deleted_at: Date = Date()) {
        self.id = id
        self.username = username
        self.email = email
        self.contact = contact
        self.password = password
        self.image = image
        self.role = role
        self.created_at = created_at
        self.updated_at = updated_at
        self.delete_at = deleted_at
    }
}
