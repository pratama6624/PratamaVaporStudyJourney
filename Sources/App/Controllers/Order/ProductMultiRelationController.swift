//
//  ProductMultiRelationController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 19/03/25.
//

import Vapor
import Fluent

struct ProductMultiRelationController: RouteCollection, @unchecked Sendable {
    func boot(routes: any RoutesBuilder) throws {
        let products = routes.grouped("product_multi_relations")
        
        products.get(use: self.index)
            .withMetadata("Get all products", "Product Multi Relations Controller")
        
        products.post(use: self.create)
            .withMetadata("Create a new product", "Product Multi Relations Controller")
        
        products.group(":productID") { product in
            product.get(use: self.show)
                .withMetadata("Show product by id", "Product Multi Relations Controller")
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [ProductRelation] {
        try await ProductRelation.query(on: req.db).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> ProductRelation {
        let product = try req.content.decode(ProductRelation.self)
        
        try await product.save(on: req.db)
        return product
    }
    
    @Sendable
    func show(req: Request) async throws -> ProductRelation {
        guard let product = try await ProductRelation.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound, reason: "Wrong id")
        }
        
        return product
    }
}
