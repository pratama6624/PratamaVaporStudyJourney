//
//  PostCreateRequest.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 12/03/25.
//

import Vapor

struct PostCreateRequest: Content {
    let title: String
    let userID: UUID?
}
