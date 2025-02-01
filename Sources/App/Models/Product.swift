//
//  Product.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 01/02/25.
//

import Vapor
import Fluent

// Hooks afterDecode & beforeEncode -> PostgreSQL
final class Product: Model, Content, @unchecked Sendable {
    static let schema: String = "products"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "price")
    var price: Double
    
    @Field(key: "category")
    var category: String
    
    @Field(key: "cost_price")
    var cost_price: Double
    
    @Field(key: "api_key")
    var api_key: String
    
    init() { }
    
    init(id: UUID? = nil, name: String, price: Double, category: String, cost_price: Double, api_key: String) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.cost_price = cost_price
        self.api_key = api_key
    }
    
    func toProductDTO() -> ProductDTO {
        // Panggil secara manual
        try? self.beforeEncode()
        
        // Rubah ke DTO
        let productDTO = ProductDTO(
            id: self.id,
            name: self.$name.value,
            price: self.$price.value,
            category: self.$category.value
        )
        
        // Kembalikan dalam format DTO
        return productDTO
    }
    
    // Hooks -> afterDecode
    // Menangani POST request dari ProductController
    func afterDecode() throws {
        self.name = self.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.name.isEmpty {
            throw Abort(.badGateway, reason: "Product name cannot be empty")
        }
        
        if self.price < 1 {
            throw Abort(.badGateway, reason: "Price must be greater than or equal to 1")
        }
    }
    
    // Hooks -> beforeEncode
    // Menangani response untuk GET ProductController
    func beforeEncode() throws {
        self.category = self.category.uppercased()
    }
}
