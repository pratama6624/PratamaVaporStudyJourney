import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.routes.defaultMaxBodySize = "5mb"
    
    // Override Defaults -> Global
    let encoder = JSONEncoder()
    // Default -> .iso8601
    encoder.dateEncodingStrategy = .secondsSince1970
    // Default -> Camel Case
    encoder.keyEncodingStrategy = .convertToSnakeCase
    // Pretty Printed
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    ContentConfiguration.global.use(encoder: encoder, for: .json)

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    // Song Migration
    app.migrations.add(CreateSong())
    
    // Product Migration
    app.migrations.add(CreateProduct())
    app.migrations.add(AddCreatedAtToProduct())
    app.migrations.add(UpdateProductDefaultCreatedAt())
    
    // UserPostgre
    app.migrations.add(CreateUserPostgre())
    
    // Auto migration
    try await app.autoMigrate()
    // register routes
    try routes(app)
}
