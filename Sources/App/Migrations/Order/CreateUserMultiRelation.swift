//
//  CreateUserMultiRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/03/25.
//

import Fluent

struct CreateUserMultiRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("user_multi_relations")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .unique(on: "email")
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("user_multi_relations").delete()
    }
}

// DONE
