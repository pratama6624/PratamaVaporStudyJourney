//
//  UserMultiRelationController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 18/03/25.
//

import Vapor
import Fluent

struct UserMultiRelationController: RouteCollection, @unchecked Sendable {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("user_multi_relations")
        
        users.get(use: self.index)
            .withMetadata("Get all users", "User Multi Relations Controller")
        
        users.post(use: self.create)
            .withMetadata("Create a new user", "User Multi Relations Controller")
        
        users.delete(use: self.deleteUser)
            .withMetadata("Delete user", "User Multi Relations Controller")
        
        users.group(":userID") { user in
            user.get(use: self.show)
                .withMetadata("Show user by id", "User Multi Relations Controller")
        }
    }
    
    // Data Read -> GET ALL
    @Sendable
    func index(req: Request) async throws -> [UserRelation] {
        try await UserRelation.query(on: req.db).with(\.$orders).all()
    }
    
    // Data Create -> POST SINGLE & MULTIPLE
    @Sendable
    func create(req: Request) async throws -> Response {
        let users: [UserRelation]
        
        if let userArray = try? req.content.decode([UserRelation].self) {
            users = userArray
        } else if let singleUser = try? req.content.decode(UserRelation.self) {
            users = [singleUser]
        } else {
            let res = Response(status: .badRequest)
            try res.content.encode(["error": "Invalid JSON format"])
            return res
        }
        
        var createdUsers: [[String: String]] = []
        var errors: [[String: String]] = []
        
        for user in users {
            do {
                try await user.save(on: req.db)
                createdUsers.append([
                    "id": user.id?.uuidString ?? "",
                    "name": user.name,
                    "email": user.email
                ])
            } catch let dbError as DatabaseError where dbError.isConstraintFailure {
                errors.append([
                    "email": user.email,
                    "error": "Email '\(user.email)' sudah terdaftar."
                ])
            } catch {
                errors.append([
                    "email": user.email,
                    "error": "Terjadi kesalahan saat menyimpan data."
                ])
            }
        }
        
        let status: HTTPResponseStatus = createdUsers.isEmpty
            ? .conflict
            : (errors.isEmpty ? .created : .multiStatus)
        
        let response = Response(status: status)
        try response.content.encode([
            "created": createdUsers,
            "errors": errors
        ])
        
        return response
    }
    
    // Data Read -> GET BY ID
    @Sendable
    func show(req: Request) async throws -> UserRelation {
        guard let user = try await
            UserRelation.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound, reason: "Wrong id")
        }
        
        return user
    }
    
    // Data Delete -> DELETE BY ID SINGLE & MULTIPLE
    @Sendable
    func deleteUser(req: Request) async throws -> Response {
        var idsToDelete: [UUID] = []
        
        // 1 Object
        if let single = try? req.content.decode([String: String].self), let idString = single["id"], let uuid = UUID(uuidString: idString) {
            idsToDelete = [uuid]
        }
        // multiple object
        else if let array = try? req.content.decode([[String: String]].self) {
            idsToDelete = array.compactMap { dict in
                guard let idString = dict["id"] else { return nil }
                return UUID(uuidString: idString)
            }
        } else {
            let response = Response(status: .badRequest)
            try response.content.encode([
                "deleted": [],
                "errors": [["error": "Invalid JSON format. Provide 'id' as object or array of objects."]]
            ])
            return response
        }
        
        var deleted: [[String: String]] = []
        var errors: [[String: String]] = []
        
        for id in idsToDelete {
            if let user = try await UserRelation.find(id, on:req.db) {
                try await user.delete(on: req.db)
                deleted.append(["id": id.uuidString])
            } else {
                errors.append(["id": id.uuidString, "error": "User not found"])
            }
        }
        
        let status: HTTPResponseStatus = deleted.isEmpty ? .notFound : (errors.isEmpty ? .ok : .multiStatus)
        let response = Response(status: status)
        try response.content.encode([
            "deleted": deleted,
            "errors": errors
        ])
        return response
    }
}

// DONE
