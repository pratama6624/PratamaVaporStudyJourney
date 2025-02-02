//
//  AddCreatedAtToProduct.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 02/02/25.
//

import Fluent

// Add field created_at to products
struct AddCreatedAtToProduct: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("products")
            .field("created_at", .datetime)
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("products")
            .deleteField("created_at")
            .update()
    }
}
