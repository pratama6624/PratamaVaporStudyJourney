//
//  EnvironmentExtension.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 05/03/25.
//

import Vapor

extension Environment {
    static var staging: Environment {
        .custom(name: "staging")
    }
}

