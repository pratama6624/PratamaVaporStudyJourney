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
            .withMetadata("Test Without HRE", "Validation Controller")
        
    }
    
    @Sendable
    func validationTestWithoutHRE(req: Request) async throws -> ValidationDTO {
        let user = try req.content.decode(ValidationDTO.self)
        
        return user
    }
}
