//
//  CreateOrderMultiRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/03/25.
//

import Fluent

struct CreateOrderMultiRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("order_multi_relations")
            .id()
            .field("user_id", .uuid, .required, .references("user_multi_relations", "id", onDelete: .cascade))
            .field("payment_id", .uuid, .references("payment_multi_relations", "id", onDelete: .setNull))
            .field("shipping_id", .uuid, .references("shipping_multi_relations", "id", onDelete: .setNull))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema( "order_multi_relations" ).delete()
    }
}
