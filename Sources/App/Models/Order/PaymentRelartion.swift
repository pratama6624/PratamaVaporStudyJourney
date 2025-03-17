//
//  PaymentRelartion.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 15/03/25.
//

import Vapor
import Fluent

final class PaymentRelation: Model, Content, @unchecked Sendable {
    static let schema: String = "payment_multi_relations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "method")
    var method: String
    
    @Field(key: "amount")
    var amount: Double
    
    // One to One
    @OptionalChild(for: \.$payment)
    var orders: OrderRelation?
    
    init() { }
    
    init(id: UUID? = nil, method: String, amount: Double) {
        self.id = id
        self.method = method
        self.amount = amount
    }
}
