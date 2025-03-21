//
//  ShippingMultiRelationController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 21/03/25.
//

import Vapor
import Fluent

struct ShippingMultiRelationController: RouteCollection, @unchecked Sendable {
    func boot(routes: any RoutesBuilder) throws {
        let shipping = routes.grouped("shipping_multi_relations")
        
        shipping.get(use: self.index)
            .withMetadata("Get all shippings", "Shipping Multi Relations Controller")
        
        shipping.post(use: self.create)
            .withMetadata("Create a new shipping", "Shipping Multi Relations Controller")
        
        shipping.group(":shippingID") { shipping in
            shipping.get(use: self.show)
                .withMetadata("Show a shipping by id", "Shipping Multi Relations Controller")
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [ShippingRelation] {
        try await ShippingRelation.query(on: req.db).with(\.$orders).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> ShippingRelation {
        let shipping = try req.content.decode(ShippingRelation.self)
        
        try await shipping.save(on: req.db)
        return shipping
    }
    
    @Sendable
    func show(req: Request) async throws -> ShippingRelation {
        guard let shipping = try await ShippingRelation.find(req.parameters.get("shippingID"), on: req.db) else {
            throw Abort(.notFound, reason: "Wrong id")
        }
        
        return shipping
    }
}
