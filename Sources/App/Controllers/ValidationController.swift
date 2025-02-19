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
        
        // Validating Request Query
        // -> GET /validation-test/user?name=pratama&email=pratama@gmail.com&age=25&favoriteColor=green
        validationTest.grouped(ValidationMiddleware()).get("user", use: self.getusershell)
            .withMetadata("Test get user with validation", "Validation Controller")
        
        // Custom Validator
        // -> GET /validation-test/validate?zipCode=12345
        validationTest.grouped(ValidationMiddleware()).get("validate", use: self.validateZipCodeHandler)
            .withMetadata("Test custom validator", "Validation Controller")
    }
    
    // Because one path to this DTO request will run with validation because validation has been added (if you regiter the validator middleware)
    @Sendable
    func validationTestWithoutHRE(req: Request) async throws -> ValidationDTO {
        let user = try req.content.decode(ValidationDTO.self)
        
        return user
    }
    
    // After adding validation to the DTO
    @Sendable
    func validationTestWithHRE(req: Request) async throws -> ValidationDTO {
        
        // Validation - Register
        // Validating Request Content
        try ValidationDTO.validate(content: req)
        
        let user = try req.content.decode(ValidationDTO.self)
        
        return user
    }
    
    // Validating Request Query
    @Sendable
    func getusershell(req: Request) async throws -> ValidationDTO {
        // Optional Handling
        guard let name = req.query[String.self, at: "name"],
              let email = req.query[String.self, at: "email"],
              let age = req.query[Int.self, at: "age"],
              let favoriteColorString = req.query[String.self, at: "favoriteColor"] else {
                throw Abort(.badRequest, reason: "Missing required query parameters")
            }
        
        let favoriteColor = Color(rawValue: favoriteColorString)
        
        try ValidationDTO.validate(query: req)
        
        let user = ValidationDTO(name: name, email: email, age: age, favoriteColor: favoriteColor!)
        
        return user
    }
    
    // Custom Validator
    @Sendable
    func validateZipCodeHandler(req: Request) async throws -> CustomValidationDTO {
        try CustomValidationDTO.validate(query: req)
        let zipCodeDTO = try req.query.decode(CustomValidationDTO.self)
        
        // Custom validator (manual)
        // Must be called independently
//        try zipCodeDTO.validateZipCode()
        
        return zipCodeDTO
    }
}
