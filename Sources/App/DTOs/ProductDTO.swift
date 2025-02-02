//
//  ProductDTO.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 01/02/25.
//

import Vapor
import Fluent

// Hooks afterDecode & beforeEncode -> PostgreSQL
struct ProductDTO: Content {
    var id: UUID?
    var name: String?
    var price: Double?
    var category: String?
    var created_at: Date?
    
    func toProductModel() async throws -> Product {
        let model = Product()
        
        model.id = self.id
        
        if let name = self.name {
            model.name = name
        }
        
        if let price = self.price, price < 1 {
            throw Abort(.badRequest, reason: "Price must be greater than 0")
        }
        
        if let category = self.category {
            model.category = category
        }
        
        return model
    }
}
