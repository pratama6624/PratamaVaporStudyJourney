//
//  ProductRelation.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/03/25.
//

import Vapor
import Fluent

// Batasan studi kasus
// Field hanya 3 saja (id, name, & price) No need anything else

final class ProductRelation: Model, Content, @unchecked Sendable {
    static let schema: String = "product_multi_relations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "price")
    var price: Double
    
    // Many to Many
    // Note : Ditampilkan di sisi produk jika ada get (by id single or get all)
    @Siblings(through: OrderProductPivot.self, from: \.$product, to: \.$order)
    var orders: [OrderRelation]
    
    init() { }
    
    init(id: UUID? = nil, name: String, price: Double) {
        self.id = id
        self.name = name
        self.price = price
    }
}

// DONE
