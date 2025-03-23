//
//  UpdateOrderProductMultiRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 23/03/25.
//

import Fluent

struct UpdateOrderProductMultiRelation: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("order_product_pivot_multi_relations")
            .field("quantity", .int, .required)
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("order_product_pivot_multi_relations")
            .deleteField("quantity")
            .update()
    }
}
