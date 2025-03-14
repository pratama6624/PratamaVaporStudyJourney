//
//  ProductResponse.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 14/03/25.
//

import Vapor
import Fluent

struct ProductResponse: Content {
    var id: UUID?
    var name: String
    var price: Double
    var category: CategoryModelRelations?
    
    init(product: ProductModelRelations) {
        self.id = product.id
        self.name = product.name
        self.price = product.price
        self.category = product.category
    }
}
