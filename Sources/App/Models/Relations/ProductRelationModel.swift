//
//  ProductModel.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 13/03/25.
//

import Vapor
import Fluent

// Many to One
final class ProductRelationModel: Model, Content, @unchecked Sendable {
    static let schema: String = "product_relations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "price")
    var price: Double
    
    @OptionalParent(key: "category_id")
    var category: CategoryRelationModel?
    
    init() { }
    
    init(id: UUID? = nil, name: String, price: Double, categoryID: UUID? = nil) {
        self.id = id
        self.name = name
        self.price = price
        self.$category.id = categoryID
    }
}
