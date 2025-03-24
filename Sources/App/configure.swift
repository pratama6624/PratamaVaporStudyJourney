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
//    app.logger.logLevel = .trace
    
    // Logging
    // File logging
    // Custom Handler Logging Without LoggingSystem.bootstrap
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
    
    // Test get api key from env
    let openAIKey = Environment.get("OPENAI_API_KEY") ?? "No API Key found"
    app.logger.info("Open AI Key: \(openAIKey)")
    
    let foo = Environment.get("FOO") ?? "foo"
    let bar = Environment.get("BAR") ?? "bar"
    let foobar = Environment.get("FOOBAR") ?? "foobar"
    app.logger.info("\(foo), \(bar), \(foobar)")
    
    // Test cek environment
    switch app.environment {
    case .production:
        app.logger.info("Running in Production mode")
        app.logger.logLevel = .info
    case .development:
        app.logger.info("Running in Development mode")
        app.logger.logLevel = .trace
    case .staging:
        app.logger.info("Running in Staging mode")
        app.logger.logLevel = .debug
    default:
        app.logger.info("Running in Unknown mode")
    }
    
    // Get log level
    print(app.logger.info("Current log level: \(app.logger.logLevel)"))
    // Get log enviroment
    print(app.logger.info("Running in \(app.environment.name) mode"))
    
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
    
    // Galaxy
    app.migrations.add(CreateGalaxy())
    
    // Models -> Relations
    app.migrations.add(CreateUserRelation())
    app.migrations.add(CreatePostRelation())
    app.migrations.add(CreateCategoryRelation())
    app.migrations.add(CreateProductRelation())
    // Seeder
    app.migrations.add(SeedUserRelation())
    app.migrations.add(SeedCategoryRelation())
    
    // Multi Relation
    app.migrations.add(CreateUserMultiRelation())
    app.migrations.add(CreatePaymentMultiRelation())
    app.migrations.add(CreateShippingMultiRelation())
    app.migrations.add(CreateProductMultiRelation())
    app.migrations.add(CreateOrderMultiRelation())
    app.migrations.add(CreateOrderProductMultiRelation())
    
    app.migrations.add(UpdateShippingMultiRelation())
    app.migrations.add(UpdateProductMultiRelation())
    app.migrations.add(UpdateOrderProductMultiRelation())
    app.migrations.add(UpdatePaymentMultiRelation())
    
    app.logger.info("Migrations completed successfully")
    
    // Auto migration
    try await app.autoMigrate()
    app.logger.info("Auto-migration completed")
    // register routes
    try routes(app)
    app.logger.info("Routes registered successfully")
    app.logger.info("Vapor is ready to run!")
}
