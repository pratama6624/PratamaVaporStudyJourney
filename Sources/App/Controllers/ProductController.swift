//
//  ProductController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 01/02/25.
//

import Vapor

struct ProductController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let product = routes.grouped("products")
        
        product.get(use: self.index)
            .withMetadata("Show all products", "Product Controller")
        
        product.post(use: self.create)
            .withMetadata("Create a new product", "Product Controller")
    }
    
    // -> GET /products
    @Sendable
    func index(req: Request) async throws -> Response {
        let products = try await Product.query(on: req.db).all().map { $0.toProductDTO()}
        
        // One-off
        // Hanya berlaku di request ini saja
        let encoder = JSONEncoder()
        // Date time format
        encoder.dateEncodingStrategy = .iso8601
        // Output style json
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        // Encode
        let jsonData = try encoder.encode(products)
        
        return Response(status: .ok, body: .init(data: jsonData))
    }
    
    // -> POST /products
    @Sendable
    func create(req: Request) async throws -> ProductDTO {
        // From JSON to Object Model (Decode)
        let product = try req.content.decode(Product.self)
        
        product.created_at = Date()
        
        // Save to database
        try await product.save(on: req.db)
        
        // Response to client
        return product.toProductDTO()
    }
}
