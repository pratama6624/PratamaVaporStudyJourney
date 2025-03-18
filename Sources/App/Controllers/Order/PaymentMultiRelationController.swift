//
//  PaymentMultiRelationController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 18/03/25.
//

import Vapor
import Fluent

struct PaymentMultiRelationController: RouteCollection, @unchecked Sendable {
    func boot(routes: RoutesBuilder) throws {
        let payment = routes.grouped("payment_multi_relations")
        
        payment.get(use: self.index)
            .withMetadata("Get all payment", "Payment Multi Relations Controller")
        
        payment.post(use: self.create)
            .withMetadata("Create a new payment", "Payment Multi Relations Controller")
        
        payment.group(":paymentID") { payment in
            payment.get(use: self.show)
                .withMetadata("Show payment by id", "Payment Multi Relations Controller")
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [PaymentRelation] {
        try await PaymentRelation.query(on: req.db).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> PaymentRelation {
        let payment = try req.content.decode(PaymentRelation.self)
        
        try await payment.save(on: req.db)
        return payment
    }
    
    @Sendable
    func show(req: Request) async throws -> PaymentRelation {
        guard let payment = try await PaymentRelation.find(req.parameters.get("paymentID"), on: req.db) else {
            throw Abort(.notFound, reason: "Wrong id")
        }
        
        return payment
    }
}
