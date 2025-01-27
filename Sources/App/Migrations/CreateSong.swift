//
//  CreateSong.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 27/01/25.
//

import Fluent

struct CreateSong: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("songs")
            .id()
            .field("title", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("songs").delete()
    }
}
