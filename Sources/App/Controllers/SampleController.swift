//
//  SongSampleDocController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 29/01/25.
//

import Vapor
import Fluent

struct SampleController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        // Grouping Routes
        let songs = routes.grouped("sample", "songs")
        
        // -> GET /songs
        songs.get(use: self.index)
            .withMetadata("Show all songs", "Sample Controller")
        // -> POST /songs
        songs.post(use: self.create)
            .withMetadata("Add a new song", "Sample Controller")
        
        // Nested Grouping
        songs.group(":id") { song in
            song.get(use: self.show)
                .withMetadata("Show song detail", "Sample Controller")
            song.put(use: self.update)
                .withMetadata("Update song", "Sample Controller")
            song.delete(use: self.delete)
                .withMetadata("Delete song", "Sample Controller")
        }
    }
    
    // -> GET Request /songs
    @Sendable
    func index(req: Request) async throws -> String {
        "List of all songs"
    }
    
    // -> POST Request /songs
    @Sendable
    func create(req: Request) async throws -> String {
        "Add a new song"
    }
    
    // -> GET Request /songs/:id
    @Sendable
    func show(req: Request) async throws -> String {
        // optional Handling
        guard let songID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        return "Show song detail with song id \(songID)"
    }
    
    // -> PUT Request /songs/:id
    @Sendable
    func update(req: Request) async throws -> String {
        // optional Handling
        guard let songID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        return "Update song detail with song id \(songID)"
    }
    
    // -> DELETE Request /songs/:id
    @Sendable
    func delete(req: Request) async throws -> String {
        // optional Handling
        guard let songID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        return "Delete song detail with song id \(songID)"
    }
}
