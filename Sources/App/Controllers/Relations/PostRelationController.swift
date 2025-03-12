//
//  PostRelationController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 12/03/25.
//

import Vapor
import Fluent

struct PostRelationController: RouteCollection, @unchecked Sendable {
    func boot(routes: any RoutesBuilder) throws {
        let postit = routes.grouped("postrelation")
        
        postit.get(use: self.index)
            .withMetadata("Get all", "Post Relations Controller")
        
        postit.post(use: self.createPost)
            .withMetadata("Create", "Post Relations Controller")
        
        postit.group(":postID") { post in
            post.get(use: self.show)
                .withMetadata("Show", "Post Relations Controller")
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [PostRelationModel] {
        try await PostRelationModel.query(on: req.db).with(\.$user).all()
    }
    
    @Sendable
    func createPost(req: Request) async throws -> PostResponse {
        let data = try req.content.decode(PostCreateRequest.self)

        // Cek apakah userID valid jika diberikan
        if let userID = data.userID {
            guard let _ = try await UserRelationModel.find(userID, on: req.db) else {
                throw Abort(.notFound, reason: "User tidak ditemukan")
            }
        }

        let post = PostRelationModel(title: data.title, userID: data.userID)
        try await post.save(on: req.db)

        // Load data dengan eager loading untuk relasi User
        let savedPost = try await PostRelationModel.query(on: req.db)
            .with(\.$user) // 👈 Eager Load agar user tidak nil
            .filter(\.$id == post.id!)
            .first()

        guard let savedPost = savedPost else {
            throw Abort(.internalServerError, reason: "Gagal menyimpan post")
        }

        return PostResponse(post: savedPost)
    }
    
    @Sendable
    func show(req: Request) async throws -> PostRelationModel {
        guard let post = try await PostRelationModel.find(req.parameters.get("postID"), on: req.db) else {
            throw Abort(.notFound, reason: "Wrong id")
        }
        
        return post
    }
}
