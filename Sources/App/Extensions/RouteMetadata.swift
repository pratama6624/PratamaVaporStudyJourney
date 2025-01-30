//
//  RouteMetadata.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 30/01/25.
//

import Vapor

extension Route {
    @discardableResult
    func withMetadata(_ description: String, _ category: String) -> Route {
        self.description(description)
        self.userInfo["category"] = category
        return self
    }
}
