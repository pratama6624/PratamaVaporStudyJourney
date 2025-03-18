import Fluent
import Vapor

func routes(_ app: Application) throws {
    // Merubah ke Case Insensitive
    app.routes.caseInsensitive = true
    app.http.client.configuration.redirectConfiguration = .disallow
    
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
    
    // Vapor = case sensitive URL (default)
    // -> GET /HelloVapor = valid route
    // -> GET /hellovapor = 404 Not Found
    app.on(.GET, "HelloVapor") { req async -> String in
        "Vapor Valid Route"
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
    
    // Redirect -> GET /old-route
    app.get("old-route") { req async in
        req.redirect(to: "/new-route")
    }
    
    // -> GET /new-route
    app.get("new-route") { req async -> String in
        "This is new route"
    }
    
    // Route Controller Register
    try app.register(collection: TodoController())
    
    // Route Collection Register
    try app.register(collection: PlaylistController())
    
    // Route Controller Register -> SongController
    try app.register(collection: SongController())
    
    // Route Controller Sample Register
    try app.register(collection: SampleController())
    
    // Route Controller User Register (How Content Works)
    try app.register(collection: UserController())
    
    // Route Controller IO Register (Body Streaming)
    try app.register(collection: IOController())
    
    // Route Controller Product Register
    try app.register(collection: ProductController())
    
    // Route Controller User Postgre Register
    try app.register(collection: UserPostgreController())
    
    // Route Controller Open Weather Controller Register
    try app.register(collection: WeatherController())
    
    // Route Controller Client Content Test Using Httpbin API
    try app.register(collection: ClientContentTestController())
    
    // Route Controller Validation Register
    try app.register(collection: ValidationController())
    
    // Route Controller Async Register
    try app.register(collection: AsyncController())
    
    // Route Controller ELF Register
    try app.register(collection: EventLoopController())
    
    // Route Controller Blocking Bound Controller
    try app.register(collection: BlockingBoundController())
    
    // Route Controller Logging
    try app.register(collection: LoggingController())
    
    // Route Controller Error
    try app.register(collection: ErrorController())
    
    // Route Controller Galaxy
    try app.register(collection: GalaxyController())
    
    // Route Controller Relations
    try app.register(collection: UserRelationController())
    try app.register(collection: PostRelationController())
    try app.register(collection: CategoryRelationController())
    try app.register(collection: ProductRelationController())
    
    // Route Controller Multi Relations
    try app.register(collection: UserMultiRelationController())
    
    // Viewing all route
    // Terminal -> swift run App routes
    print(app.routes.all)
}
