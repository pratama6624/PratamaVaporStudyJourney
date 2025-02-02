//
//  UpdateProductDefaultCreatedAt.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 02/02/25.
//

import Fluent

// Tambahkan .required, .sql(.default("NOW()"))
struct UpdateProductDefaultCreatedAt: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("products")
            .deleteField("created_at")
            .field("created_at", .datetime, .required, .sql(.default("NOW()")))
            .update()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("products")
            .deleteField("created_at")
            .field("created_at", .datetime)
            .update()
    }
}
