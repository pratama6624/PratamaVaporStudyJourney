//
//  CreateUserRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 12/03/25.
//

import Fluent

struct CreateUserRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("user_relations")
            .id()
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("user_relations").delete()
    }
}
