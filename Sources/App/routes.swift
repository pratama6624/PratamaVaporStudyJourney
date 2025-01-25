import Fluent
import Vapor

func routes(_ app: Application) throws {
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
    
    try app.register(collection: TodoController())
}
