//
//  ShippingRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/03/25.
//

import Vapor
import Fluent

final class ShippingRelation: Model, Content, @unchecked Sendable {
    static let schema: String = "shipping_relations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "carrier")
    var carrier: String
    
    // One to Many
    @Children(for: \.$shipping)
    var orders: [OrderRelation]
    
    init() { }
    
    init(id: UUID? = nil, carrier: String) {
        self.id = id
        self.carrier = carrier
    }
}
