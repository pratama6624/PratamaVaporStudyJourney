//
//  ProductRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/03/25.
//

import Vapor
import Fluent

final class ProductRelation: Model, Content, @unchecked Sendable {
    static let schema: String = "product_relations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(through: OrderProductPivot.self, from: \.$product, to: \.$order)
    var orders: [OrderRelation]
    
    init() { }
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
