//
//  CreateShippingMultiRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 17/03/25.
//

import Fluent

struct CreateShippingMultiRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("shipping_multi_relations")
            .id()
            .field("carrier", .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("shipping_multi_relations").delete()
    }
}
