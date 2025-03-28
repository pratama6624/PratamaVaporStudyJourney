//
//  CategoryRelationController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 13/03/25.
//

import Vapor
import Fluent

struct CategoryRelationController: RouteCollection, @unchecked Sendable {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("categoryrelations")
        
        categories.get(use: self.index)
            .withMetadata("Get all", "Category Relations Controller")
        
        categories.post(use: self.create)
            .withMetadata("Create a category", "Category Relations Controller")
        
        categories.group(":categoryID") { category in
            category.get(use: self.show)
                .withMetadata("Show category by ID", "Category Relations Controller")
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [CategoryRelationModel] {
        try await CategoryRelationModel.query(on: req.db).with(\.$products).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> CategoryRelationModel {
        let category = try req.content.decode(CategoryRelationModel.self)
        
        try await category.save(on: req.db)
        return category
    }
    
    @Sendable
    func show(req: Request) async throws -> CategoryRelationModel {
        guard let category = try await CategoryRelationModel.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound, reason: "Wrong id")
        }
        
        return category
    }
}
