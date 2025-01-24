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
    
    try app.register(collection: TodoController())
}
