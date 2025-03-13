//
//  CreateCategory.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 13/03/25.
//

import Fluent

struct CreateCategoryRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("categories_relations")
            .id()
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("categories_relations").delete()
    }
}
