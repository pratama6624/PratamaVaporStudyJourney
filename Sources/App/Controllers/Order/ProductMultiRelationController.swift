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
    
    // Data Read -> GET ALL
    @Sendable
    func index(req: Request) async throws -> [ProductRelation] {
        try await ProductRelation.query(on: req.db).with(\.$orders).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> ProductRelation {
        let product = try req.content.decode(ProductRelation.self)
        
        try await product.save(on: req.db)
        return product
    }
    
    // Data Read -> GET BY ID
    @Sendable
    func show(req: Request) async throws -> ProductRelation {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing product ID")
        }
        
        guard let product = try await ProductRelation.query(on: req.db)
            .with(\.$orders)
            .filter(\.$id == productID)
            .first() else {
            throw Abort(.notFound, reason: "Product with the given ID not found")
        }
        
        return product
    }
}
