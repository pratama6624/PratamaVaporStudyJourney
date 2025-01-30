//
//  PlaylistController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 30/01/25.
//

import Vapor

struct PlaylistController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let playlists = routes.grouped("playlists")
        
        // -> GET /playlists
        playlists.get { req async -> String in
            "All playlists"
        }
        .withMetadata("Show all playlists", "Playlist Controller")
        
        
        // -> POST /playlists
        playlists.post { req async -> String in
            "Create a new playlist"
        }
        .withMetadata("Creaate a new playlist", "Playlist Controller")
        
        // Nested Routes /playlists/:id
        playlists.group(":id") { playlists in
            // -> GET /playlists/:id
            playlists.get { req async -> String in
                "Show playlist with id: \(req.parameters.get("id")!)"
            }
            .withMetadata("Show playlist detail", "Playlist Controller")
            
            // -> PATCH /playlists/:id
            playlists.patch { req async -> String in
                "Update playlist with id: \(req.parameters.get("id")!)"
            }
            .withMetadata("Update playlist", "Playlist Controller")
            
            // -> PUT /playlists/:id
            playlists.put { req async -> String in
                "Replace playlist with id: \(req.parameters.get("id")!)"
            }
            .withMetadata("Delete playlist", "Playlist Controller")
        }
    }
}
