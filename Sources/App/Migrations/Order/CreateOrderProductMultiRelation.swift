//
//  CreateOrderProductMultiRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 17/03/25.
//

import Fluent

struct CreateOrderProductMultiRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("order_product_pivot_multi_relations")
            .id()
            .field("order_id", .uuid, .required, .references("order_multi_relations", "id", onDelete: .cascade))
            .field("product_id", .uuid, .required, .references("product_multi_relations", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("order_product_pivot_multi_relations").delete()
    }
}
