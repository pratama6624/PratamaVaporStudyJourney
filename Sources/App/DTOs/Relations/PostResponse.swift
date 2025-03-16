//
//  PostResponse.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 12/03/25.
//

import Vapor
import Fluent

struct PostResponse: Content {
    var id: UUID?
    var title: String
    var user: UserRelationModel?

    init(post: PostRelationModel) {
        self.id = post.id
        self.title = post.title
        self.user = post.user
    }
}
