//
//  PlaylistRoutes.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 26/01/25.
//

import Vapor

struct PlaylistRoutes: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let playlists = routes.grouped("playlists")
        
        // -> GET /playlists
        playlists.get { req async -> String in
            "All playlists"
        }
        
        // -> POST /playlists
        playlists.post { req async -> String in
            "Create a new playlist"
        }
        
        // Nested Routes /playlists/:id
        playlists.group(":id") { playlists in
            // -> GET /playlists/:id
            playlists.get { req async -> String in
                "Show playlist with id: \(req.parameters.get("id")!)"
            }
            
            // -> PATCH /playlists/:id
            playlists.patch { req async -> String in
                "Update playlist with id: \(req.parameters.get("id")!)"
            }
            
            // -> PUT /playlists/:id
            playlists.put { req async -> String in
                "Replace playlist with id: \(req.parameters.get("id")!)"
            }
        }
    }
}
