//
//  ShippingRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/03/25.
//

import Vapor
import Fluent

final class ShippingRelation: Model, Content, @unchecked Sendable {
    static let schema: String = "shipping_multi_relations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "carrier")
    var carrier: String
    
    @Field(key: "cost")
    var cost: Double
    
    @Field(key: "address")
    var address: String
    
    // One to Many
    @Children(for: \.$shipping)
    var orders: [OrderRelation]
    
    init() { }
    
    init(id: UUID? = nil, carrier: String, cost: Double, address: String) {
        self.id = id
        self.carrier = carrier
        self.cost = cost
        self.address = address
    }
}
