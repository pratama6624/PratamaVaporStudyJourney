import Fluent
import Vapor

func routes(_ app: Application) throws {
    // /
    app.get { req async in
        "It works!"
    }

    // /hello
    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    // /hello/vapor
    app.get("hello", "vapor") { req async -> String in
        "Hello, Vapor!"
    }
    
    // /hey
    app.on(.GET, "hey") { req async -> String in
        "Hey!"
    }
    
    // /hey/vapor
    app.on(.GET, "hey", "vapor") { req async -> String in
        "Hey, Vapor!"
    }
    
    // Dynamic route
    app.on(.GET, "hello", ":name") { req async -> String in
        let name = req.parameters.get("name")!
        return "Hello, \(name)!"
    }

    try app.register(collection: TodoController())
}
