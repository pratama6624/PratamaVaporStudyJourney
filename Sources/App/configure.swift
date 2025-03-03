import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import DotEnv

// configures your application
public func configure(_ app: Application) async throws {
    // Load .env
    try DotEnv.load(path: app.directory.workingDirectory + ".env")
    
    app.logger.info("Configuring vapor application...")
    
    // Set log level
    app.logger.logLevel = .trace
    
    // Logging
    // File logging
    let logFilePath = app.directory.publicDirectory + "Logs/app.log"
    
    // Create folder
    let logsDirectory = URL(fileURLWithPath: app.directory.publicDirectory + "Logs")
    if !FileManager.default.fileExists(atPath: logsDirectory.path) {
        do {
            try FileManager.default.createDirectory(at: logsDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error: \(error)")
        }
    }
    
    // Create file log
    if !FileManager.default.fileExists(atPath: logFilePath) {
        FileManager.default.createFile(atPath: logFilePath, contents: nil, attributes: nil)
    }
    
    print("📁 Log file path: \(logFilePath)")
    // Custom logging logger SwiftLog
    let fileLogger = FileLogger(label: "vapor.fileLogger", filePath: logFilePath)
    app.logger = Logger(label: "vapor.fileLogger", factory: { _ in fileLogger })
    
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.logger.info("Middleware configured")
    
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

    app.logger.info("Setting up database")
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    app.logger.info("Database connected successfully")

    app.logger.info("Setting up migrations")
    
    // Song Migration
    app.migrations.add(CreateSong())
    
    // Product Migration
    app.migrations.add(CreateProduct())
    app.migrations.add(AddCreatedAtToProduct())
    app.migrations.add(UpdateProductDefaultCreatedAt())
    
    // UserPostgre
    app.migrations.add(CreateUserPostgre())
    
    // User
    app.migrations.add(CreateUser())
    app.migrations.add(AddUniqueConstraintUsers())
    
    app.logger.info("Migrations completed successfully")
    
    // Auto migration
    try await app.autoMigrate()
    app.logger.info("Auto-migration completed")
    // register routes
    try routes(app)
    app.logger.info("Routes registered successfully")
    app.logger.info("Vapor is ready to run!")
}
