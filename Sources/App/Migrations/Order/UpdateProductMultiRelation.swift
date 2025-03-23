//
//  UpdateProductMultiRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 23/03/25.
//

import Fluent

struct UpdateProductMultiRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("product_multi_relations")
            .field("price", .double, .required, .sql(.default(0.0)))
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("product_multi_relations")
            .deleteField("price")
            .update()
    }
}
