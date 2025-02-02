//
//  CreateProduct.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 01/02/25.
//

import Fluent

struct CreateProduct: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("products")
            .id()
            .field("name", .string, .required)
            .field("price", .double, .required)
            .field("category", .string, .required)
            .field("cost_price", .double, .required)
            .field("api_key", .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("products").delete()
    }
}
