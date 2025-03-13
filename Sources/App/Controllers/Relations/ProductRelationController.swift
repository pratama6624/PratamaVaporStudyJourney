//
//  ProductRelationController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 13/03/25.
//

import Vapor
import Fluent

struct ProductRelationController: RouteCollection, @unchecked Sendable {
    func boot(routes: any RoutesBuilder) throws {
        let productRelationRoutes = routes.grouped("product-relations")
        
        productRelationRoutes.get(use: self.index)
            .withMetadata("Get all product relations", "Product Relations Controller")
        
        productRelationRoutes.group(":productID") { product in
            product.get(use: self.show)
                .withMetadata("Show product by ID", "Product Relations Controller")
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [ProductModelRelations] {
        try await ProductModelRelations.query(on: req.db).with(\.$category).all()
    }
    
    @Sendable
    func show(req: Request) async throws -> ProductModelRelations {
        guard let product = try await ProductModelRelations.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound, reason: "Wrong id")
        }
        
        return product
    }
}
