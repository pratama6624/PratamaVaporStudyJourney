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
        
        // -> GET /html
        // ResponseEncodable
        routes.get("html", use: self.getHtml)
            .withMetadata("return html format", "Sample Controller")
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
    
    // -> GET Request /html
    @Sendable
    func getHtml(req: Request) async throws -> HtmlDTO {
        HtmlDTO(value: """
        <!DOCTYPE html>
                <html lang="id">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Dashboard - Vapor</title>
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            background-color: #f4f4f4;
                            margin: 0;
                            padding: 0;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            height: 100vh;
                        }
                        .container {
                            background: white;
                            padding: 20px;
                            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                            border-radius: 8px;
                            text-align: center;
                        }
                        h1 {
                            color: #333;
                        }
                        p {
                            color: #666;
                        }
                        .button {
                            display: inline-block;
                            padding: 10px 20px;
                            margin-top: 15px;
                            background-color: #007BFF;
                            color: white;
                            text-decoration: none;
                            border-radius: 5px;
                            transition: background 0.3s ease;
                        }
                        .button:hover {
                            background-color: #0056b3;
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <h1>Selamat Datang di Dashboard</h1>
                        <p>Ini adalah halaman dashboard sederhana yang dibuat dengan Vapor.</p>
                        <a href="https://vapor.codes" class="button">Pelajari Vapor</a>
                    </div>
                </body>
                </html>
        """)
    }
}
