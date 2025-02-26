//
//  AddUniqueConstraintProduct.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 26/02/25.
//

import Fluent

struct AddUniqueConstraintUsers: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .unique(on: "email")
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("users")
            .deleteUnique(on: "email")
            .update()
    }
}
