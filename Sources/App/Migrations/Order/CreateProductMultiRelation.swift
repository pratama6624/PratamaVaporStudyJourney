//
//  CreateProductMultiRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 17/03/25.
//

import Fluent

struct CreateProductMultiRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("product_multi_relations")
            .id()
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("product_multi_relations").delete()
    }
}
