import Fluent
import Vapor

func routes(_ app: Application) throws {
    // Merubah ke Case Insensitive
    app.routes.caseInsensitive = true
    
    // -> GET /
    app.get { req async in
        "It works!"
    }

    // -> GET /hello
    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    // -> GET /hello/vapor
    app.get("hello", "vapor") { req async -> String in
        "Hello, Vapor!"
    }
    
    // -> GET /hey
    app.on(.GET, "hey") { req async -> String in
        "Hey!"
    }
    
    // -> GET /hey/vapor
    app.on(.GET, "hey", "vapor") { req async -> String in
        "Hey, Vapor!"
    }
    
    // Dynamic route -> GET /hello/:name
    app.on(.GET, "hello", ":name") { req async -> String in
        let name = req.parameters.get("name")!
        return "Hello, \(name)!"
    }

    // -> OPTIONS /api/users
    app.on(.OPTIONS, "api", "users") { req in
        return Response(status: .ok, headers: [
            "Allow" : "GET, POST, PUT, DELETE"
        ])
    }
    
    // Constanst -> GET /users/profile
    app.on(.GET, "users", "profile") { req async -> String in
        "User profile"
    }
    
    // Parameters -> GET /users/:id <- String UUID
    app.on(.GET, "users", ":id") { req async -> String in
        "User with id: \(req.parameters.get("id")!)"
    }
    
    // Anything -> GET /files/vaporfile
    app.on(.GET, "files", "*") { req async -> String in
        "Match any files"
    }
    
    // Catchall -> GET /api/123/profile/settings/preferences
    app.on(.GET, "api", ":userID", "profile", "*", "**") { req async -> String in
        "User id: \(req.parameters.get("userID") ?? "unknown")"
    }
    
    // Advanced Parameters -> GET /number/12
    app.on(.GET, "number", ":x") { req async throws -> String in
        guard let int = req.parameters.get("x", as: Int.self) else {
            throw Abort(.badRequest)
        }
        
        return "\(int) is a great number"
    }
    
    // responds to GET /hello/foo
    // responds to GET /hello/foo/bar
    app.on(.GET, "hello", "**") { req async -> String in
        let name = req.parameters.getCatchall().joined(separator: " ")
        return "Hello, \(name)"
    }
    
    // Body Streaming -> POST /upload
    app.on(.POST, "upload") { req -> HTTPStatus in
        let publicPath = DirectoryConfiguration.detect().publicDirectory
        let filePath = publicPath + "Uploads/Output.txt"
        
        // Buat folder jika belum ada
        let fileManager = FileManager.default
        let uploadsFolder = publicPath + "Uploads/"
        if !fileManager.fileExists(atPath: uploadsFolder) {
            let created = fileManager.createFile(atPath: filePath, contents: nil)
            guard created else {
                throw Abort(.internalServerError, reason: "Failed to create file")
            }
        }
        
        // Buka file untuk penulisan
        guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
            throw Abort(.internalServerError, reason: "Failed to open file for writing")
        }
        
        // Streaming body ke file
        req.body.drain { part in
            switch part {
            case .buffer(let buffer):
                let data = Data(buffer: buffer)
                fileHandle.write(data)
            case .end:
                try? fileHandle.close()
            default:
                break
            }
            return req.eventLoop.makeSucceededFuture(())
        }
        
        return .ok
    }
    .description("Upload file")
    .userInfo["category"] = "IO Management"
    
    // Body Streaming -> GET /download
    app.on(.GET, "download") { req -> Response in
        let publicPath = DirectoryConfiguration.detect().publicDirectory
        let filePath = publicPath + "Uploads/Output.txt"
        
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: filePath) else {
            throw Abort(.notFound, reason: "File not found")
        }
        
        let fileURL = URL(fileURLWithPath: filePath)
        return req.fileio.streamFile(at: fileURL.path)
    }
    .description("Download file")
    .userInfo["category"] = "IO Management"
    
    // Vapor = case sensitive URL (default)
    // -> GET /HelloVapor = valid route
    // -> GET /hellovapor = 404 Not Found
    app.on(.GET, "HelloVapor") { req async -> String in
        "Vapor Valid Route"
    }
    
    // Route Groups -> /songs
    app.group("songs") { songs in
        // -> GET /songs
        songs.get { req async -> String in
            "List of all songs"
        }
        
        // -> POST /songs
        songs.post { req async -> String in
            "Add a new song"
        }
        
        // Nested Group -> /songs/:id
        songs.group(":id") { id in
            // -> GET /songs/:id
            id.get { req async -> String in
                "Details of song with id \(req.parameters.get("id")!)"
            }
            
            // -> PATCH /songs/:id
            id.patch { req async -> String in
                "Update song with id \(req.parameters.get("id")!)"
            }
            
            // -> PUT /songs/:id
            id.put { req async -> String in
                "Replace song with id \(req.parameters.get("id")!)"
            }
        }
    }
    
    // Route Groups - Path Prefix
    let artists = app.grouped("artists")
    // Path Prefix -> GET /artists
    artists.get { req async -> String in
        "List of all artists"
    }
    // Path Prefix -> POST /artists
    artists.post { req async -> String in
        "Add a new artist"
    }
    // Path Prefix -> GET /artists/:id
    artists.get(":id") { req async -> String in
        "Details of artist with id \(req.parameters.get("id")!)"
    }
    
    // Middleware -> Register
    let rateLimitMiddleware = RateLimitMiddleware(maxRequest: 5, resetInterval: 60)
    
    // Without Middleware
    app.get("fast-thing") { req async -> String in
        "This is a fast route!"
    }
    
    // With Middleware
    app.group(rateLimitMiddleware) { group in
        group.get("rate-limited") { req async -> String in
            "This route is rate limited!"
        }
    }
    
    // Route Controller Register
    try app.register(collection: TodoController())
    
    // Route Collection Register
    try app.register(collection: PlaylistRoutes())
    
    // Viewing all route
    // Terminal -> swift run App routes
    print(app.routes.all)
}
