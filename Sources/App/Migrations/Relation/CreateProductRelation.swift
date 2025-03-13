//
//  CreateProduct.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 13/03/25.
//

import Fluent

struct CreateProductRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("product_relations")
            .id()
            .field("name", .string, .required)
            .field("price", .double, .required)
            .field("category_id", .uuid, .required, .references("categories_relations", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("product_relations").delete()
    }
}
