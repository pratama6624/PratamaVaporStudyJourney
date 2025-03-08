//
//  CreateGalaxy.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 08/03/25.
//

import Fluent

struct CreateGalaxy: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("galaxies")
            .id()
            .field("name", .string)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("galaxies").delete()
    }
}
