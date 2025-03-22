//
//  UpdateShippingMultiRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 22/03/25.
//

import Fluent

struct UpdateShippingMultiRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("shipping_multi_relations")
            .field("cost", .double, .required)
            .field("address", .string, .required)
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("shipping_multi_relations")
            .deleteField("cost")
            .deleteField("address")
            .update()
    }
}
