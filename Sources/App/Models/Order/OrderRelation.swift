//
//  Order.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 15/03/25.
//

import Vapor
import Fluent

// Case Study
/*
    Order -> User
        One -> One
        Many <- One
    Order -> Payment
        One -> One
        One <- One
    Order -> Shipping
        One -> One
        One <- One
    Order -> Product
        One -> Many
        Many <- Many
 */

final class OrderRelation: Model, Content, @unchecked Sendable {
    static let schema: String = "order_relations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User?
}
