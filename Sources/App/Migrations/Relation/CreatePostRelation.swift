//
//  CreatePostRelarion.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 12/03/25.
//

import Fluent

struct CreatePostRelation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("post_relations")
            .id()
            .field("title", .string, .required)
            .field("user_relation_id", .uuid, .required, .references("user_relations", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("post_relations").delete()
    }
}
