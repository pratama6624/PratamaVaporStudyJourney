//
//  CreateUserPostgre.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 07/02/25.
//

import Fluent

struct CreateUserPostgre: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("userpostgre")
            .id()
            .field("username", .string, .required)
            .field("email", .string, .required)
            .field("contact", .string, .required)
            .field("password", .string, .required)
            .field("image", .string, .required)
            .field("role", .string, .required)
            .field("created_at", .datetime, .required, .sql(.default("NOW()")))
            .field("updated_at", .datetime, .required, .sql(.default("NOW()")))
            .field("deleted_at", .datetime, .required, .sql(.default("NOW()")))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("userpostgre").delete()
    }
}
