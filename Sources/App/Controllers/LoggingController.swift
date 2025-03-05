//
//  LoggingController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 27/02/25.
//

import Vapor

struct DeleteLogError: DebuggableError {
    var identifier: String
    var reason: String
    var source: ErrorSource?
    var suggestedFixes: [String]
    
    init(identifier: String, reason: String, suggestedFixes: [String] = []) {
        self.identifier = identifier
        self.reason = reason
        self.suggestedFixes = suggestedFixes
        self.source = .capture()
    }
}

// Logging
struct LoggingController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let logging = routes.grouped("logging")
        
        // GET Request /logging/testlevel
        logging.get("testlevel", use: self.testLevel)
            .withMetadata("Test logging level", "Logging Controller")
        
        // GET Request /logging/testcustomloggerconsolelogging
        // Default console terminal only
        logging.get("testcustomloggerconsolelogging", use: self.testCustomLogger)
            .withMetadata("Test custom logger console", "Logging Controller")
        
        // GET Request /logging/testcustomloggerfilelogging
        // File logging only
        logging.get("testcustomloggerfilelogging", use: self.testCustomerFileLogger)
            .withMetadata("Test custom logger file", "Logging Controller")
        
        // GET Request /logging/deletelogfile
        // Delete log file with this request
        // Without validation
        logging.get("deletelogfile", use: self.deleteLogFile)
            .withMetadata("Test delete log file", "Logging Controller")
        
        // GET Request /logging/deletelogfilewithvalidation?username=pratama&password=scyoung6624
        // Delete log file with this request
        // With validation
        logging.get("deletelogfilewithvalidation", use: self.deleteLogFileWithValidation)
            .withMetadata("Test delete log file", "Logging Controller")
    }
    
    // Logging level test
    @Sendable
    func testLevel(req: Request) -> String {
        req.logger.info("Test level handler called")
        
        // Logging level
        req.logger.trace("This is a trace log")
        req.logger.debug("This is a debug log")
        req.logger.info("This is a info log")
        req.logger.notice("This is a notice log")
        req.logger.warning("This is a warning log")
        req.logger.error("This is a error log")
        req.logger.critical("This is a critical log")
        
        return "Hello, Welcome Developer!"
    }
    
    // Cumtom Logger -> Default console logging
    @Sendable
    func testCustomLogger(re: Request) -> String {
        let logger = Logger(label: "dev.logger.background")
        
        let startTime = Date()
        logger.info("Background task started at \(startTime)")
        
        sleep(5)
        
        let endTime = Date()
        logger.info("Background task end at \(endTime)")
        
        let duration = endTime.timeIntervalSince(startTime)
        return "Task duration \(duration) -> See details in terminal console"
    }
    
    // Custom Logger -> File logging
    @Sendable
    func testCustomerFileLogger(req: Request) -> String {
        let logger = req.logger
        
        let startTime = Date()
        logger.info("Background task started at \(startTime)")
        
        sleep(5)
        
        let endTime = Date()
        logger.info("Background task end at \(endTime)")
        
        let duration = endTime.timeIntervalSince(startTime)
        
        return "Task duration \(duration) -> See details in file app.log"
    }
    
    // Delete app.log by this
    @Sendable
    func deleteLogFile(req: Request) throws -> Response {
        let logFilePath = req.application.directory.publicDirectory + "Logs/app.log"
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: logFilePath) {
            do {
                try fileManager.removeItem(atPath: logFilePath)
                req.logger.info("Log file deleted successfully")
                return Response(status: .ok, body: .init(string: "Log file deleted successfully"))
            } catch {
                req.logger.error("Failed to delete log file")
                return Response(status: .ok, body: .init(string: "Failed to delete log file with error: \(error)"))
            }
        } else {
            req.logger.warning("Log file not found")
            return Response(status: .ok, body: .init(string: "Log file not found"))
        }
    }
    
    // Delete app.log by this
    @Sendable
    func deleteLogFileWithValidation(req: Request) throws -> Response {
        let usernameKey = "pratama"
        let passwordKey = "scyoung6624"
        
        // Username validation
        guard let username = req.query[String.self, at: "username"], username == usernameKey else {
            throw DeleteLogError(
                identifier: "DeleteLogError",
                reason: "An error occurred while deleting log data",
                suggestedFixes: ["Double check username", "Double check password"]
                )
        }
        
        // Password validation
        guard let password = req.query[String.self, at: "password"], password == passwordKey else {
            throw DeleteLogError(
                identifier: "DeleteLogError",
                reason: "An error occurred while deleting log data",
                suggestedFixes: ["Double check username", "Double check password"]
                )
        }
        
        return try deleteLogFile(req: req)
    }
}
