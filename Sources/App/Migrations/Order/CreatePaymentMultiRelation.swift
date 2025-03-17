//
//  CreatePaymentMultiRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/03/25.
//

import Fluent

struct CreatePaymentMultiRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("payment_multi_relations")
            .id()
            .field("method", .string, .required)
            .field("amount", .double, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("payment_multi_relations").delete()
    }
}
