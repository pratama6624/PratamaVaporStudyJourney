//
//  SeedUserRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 12/03/25.
//

import Vapor
import Fluent

// Seeder
struct SeedUserRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let users = [
            UserRelationModel(name: "Pratama"),
            UserRelationModel(name: "Young"),
            UserRelationModel(name: "One"),
        ]
        
        for user in users {
            try await user.save(on: database)
        }
    }
    
    func revert(on database: any Database) async throws {
        try await UserRelationModel.query(on: database).delete()
    }
}
