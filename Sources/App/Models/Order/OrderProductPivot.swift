//
//  OrderProductPivot.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/03/25.
//

import Vapor
import Fluent

final class OrderProductPivot: Model, Content, @unchecked Sendable {
    static let schema: String = "order_product_pivots"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "order_ld")
    var order: OrderRelation
    
    @Parent(key: "product_id")
    var product: ProductRelation
    
    init() { }
    
    init(id: UUID? = nil, orderID: UUID, productID: UUID) {
        self.id = id
        self.$order.id = orderID
        self.$product.id = productID
    }
}
