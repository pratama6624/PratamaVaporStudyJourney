//
//  LoggingController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 27/02/25.
//

import Vapor

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
        
        // GET Request /logging/testcustomloggerconsolelogging
        // Default console terminal only
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
}
