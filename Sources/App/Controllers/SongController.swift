//
//  SongController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 28/01/25.
//

import Vapor
import Fluent

struct SongController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        // Grouping Routes
        let songs = routes.grouped("songs")
        
        // -> GET /songs
        songs.get(use: self.index)
            .withMetadata("Show all songs", "Song Controller")
        // -> POST /songs
        songs.post(use: self.create)
            .withMetadata("Add a new song", "Song Controller")
        
        // Nested Grouping
        songs.group(":id") { song in
            // -> GET /songs/:id
            song.get(use: self.show)
                .withMetadata("Show song detail", "Song Controller")
            // -> PUT /songs/:id
            song.put(use: self.update)
                .withMetadata("Update song", "Song Controller")
            // -> DELETE /songs/:id
            song.delete(use: self.delete)
                .withMetadata("Delete song", "Song Controller")
        }
    }
    
    // -> GET Request /songs
    @Sendable
    func index(req: Request) async throws -> [SongDTO] {
        try await Song.query(on: req.db).all().map { $0.toSongDTO()}
    }
    
    // -> POST Request /songs
    @Sendable
    func create(req: Request) async throws -> SongDTO {
        let song = try req.content.decode(SongDTO.self).toModel()
        
        try await song.save(on: req.db)
        return song.toSongDTO()
    }
    
    // -> GET Request /songs/:id
    @Sendable
    func show(req: Request) async throws -> SongDTO {
        // Optional Handling
        guard let song = try await Song.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "Wrong id")
        }
        return song.toSongDTO()
    }
    
    // -> PUT Request /songs/:id
    @Sendable
    func update(req: Request) async throws -> SongDTO {
        // Optional Handling
        guard let songID = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Wrong id")
        }
        
        let updateSong = try req.content.decode(SongDTO.self)
        
        guard let existingSong = try await Song.find(songID, on: req.db) else {
            throw Abort(.notFound, reason: "Song with id \(songID) not found")
        }
        
        // Update song
        existingSong.title = updateSong.title ?? existingSong.title
        
        try await existingSong.update(on: req.db)
        
        return existingSong.toSongDTO()
    }
    
    // -> DELETE Request /songs/:id
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        // Optional Handling
        guard let song = try await Song.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "Wrong id")
        }
        
        try await song.delete(on: req.db)
        
        // return 200 OK
        return .ok
    }
}
