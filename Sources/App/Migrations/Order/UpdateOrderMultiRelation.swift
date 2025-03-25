//
//  UpdateOrderMultiRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 25/03/25.
//

import Fluent

struct UpdateOrderMultiRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("order_multi_relations")
            .deleteField("payment_id")
            .field("date", .datetime)
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("order_multi_relations")
            .field("payment_id", .uuid, .references("payment_multi_relations", "id", onDelete: .setNull))
            .deleteField("date")
            .update()
    }
}
