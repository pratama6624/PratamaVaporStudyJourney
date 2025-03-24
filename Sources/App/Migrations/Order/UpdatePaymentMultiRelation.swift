//
//  UpdatePaymentMultiRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 24/03/25.
//

import Fluent

struct UpdatePaymentMultiRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("payment_multi_relations")
            .field("date", .datetime)
            .field("order_id", .uuid, .references("order_multi_relations", "id", onDelete: .cascade))
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("payment_multi_relations")
            .deleteField("date")
            .deleteField("order_id")
            .update()
    }
}
