//
//  CategoryModel.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 13/03/25.
//

import Vapor
import Fluent

// One to Many
final class CategoryRelationModel: Model, Content, @unchecked Sendable {
    static let schema: String = "categories_relations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Children(for: \.$category)
    var products: [ProductRelationModel]
    
    init() { }
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
