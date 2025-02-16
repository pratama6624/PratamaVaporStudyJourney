//
//  ValidationController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 16/02/25.
//

import Vapor

struct ValidationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let validationTest = routes.grouped("validation-test")
        
        // Without Human-Readable Errors
        // -> POST Request /validation-test/without-hre
        validationTest.post("without-hre", use: self.validationTestWithoutHRE)
            .withMetadata("Test without HRE", "Validation Controller")
        
        // Default Error Format Response
        // With Human-Readable Errors
        // -> POST Request /validation-test/with-hre
        validationTest.post("with-hre", use: self.validationTestWithHRE)
            .withMetadata("Test with HRE default response format", "Validation Controller")
        
        // Custom Error Format Response
        // With Human-Readable Errors
        // -> POST Request /validation-test/with-hre-custom-response
        validationTest.grouped(ValidationMiddleware()).post("with-hre-custom-response", use: self.validationTestWithHRE)
            .withMetadata("Test with HRE", "Validation Controller")
    }
    
    // Because one path to this DTO request will run with validation because validation has been added
    @Sendable
    func validationTestWithoutHRE(req: Request) async throws -> ValidationDTO {
        let user = try req.content.decode(ValidationDTO.self)
        
        return user
    }
    
    // After adding validation to the DTO
    @Sendable
    func validationTestWithHRE(req: Request) async throws -> ValidationDTO {
        // Validation - Register
        try ValidationDTO.validate(content: req)
        
        let user = try req.content.decode(ValidationDTO.self)
        
        return user
    }
}
