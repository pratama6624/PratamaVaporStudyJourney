//
//  ProductCreateRequest.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 14/03/25.
//

import Vapor

struct ProductCreateRequest: Content {
    let name: String
    let price: Double
    let categoryID: UUID?
}
