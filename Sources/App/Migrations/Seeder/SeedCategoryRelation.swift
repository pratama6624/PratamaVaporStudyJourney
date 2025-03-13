//
//  SeedCategoryRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 13/03/25.
//

import Vapor
import Fluent

// Seeder
struct SeedCategoryRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let categories = [
            CategoryModelRelations(name: "Electronic"),
            CategoryModelRelations(name: "Fashion")
        ]
        
        for category in categories {
            try await category.save(on: database)
        }
    }
    
    func revert(on database: any Database) async throws {
        try await CategoryModelRelations.query(on: database).delete()
    }
}
