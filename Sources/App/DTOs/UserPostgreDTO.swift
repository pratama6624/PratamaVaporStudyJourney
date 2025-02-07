//
//  UserPostgreDTO.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 07/02/25.
//

import Vapor
import Fluent

struct UserPostgreDTO: Content {
    var id: UUID?
    var username: String?
    var email: String?
    var contact: String?
    var password: String?
    var image: String?
    var role: String?
    var created_at: Date?
    var updated_at: Date?
    var deleted_at: Date?
    
    func toUserPostgreModel() -> UserPostgre {
        let userPostgreModel = UserPostgre()
        
        userPostgreModel.id = self.id
        
        if let username = self.username {
            userPostgreModel.username = username
        }
        
        if let email = self.email {
            userPostgreModel.email = email
        }
        
        if let contact = self.contact {
            userPostgreModel.contact = contact
        }
        
        if let password = self.password {
            userPostgreModel.password = password
        }
        
        if let image = self.image {
            userPostgreModel.image = image
        }
        
        if let role = self.role {
            userPostgreModel.role = role
        }
        
        return userPostgreModel
    }
}
