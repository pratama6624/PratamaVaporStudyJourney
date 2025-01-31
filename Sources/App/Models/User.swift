//
//  User.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 29/01/25.
//

import Vapor

// Smaple -> How Content Works
struct User: Content {
    var id: UUID?
    var name: String?
    var age: Int
    
    // afterDevode (Setelah request diterima dan didecode / JSON to Object Model)
    mutating func afterDecode() throws {
        // Hilangkan space di awala dan akhir string (jika ada)
        self.name = self.name?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Jika nama ada tetapi kosong setelah trim maka lempar ke badRequest
        if let name = self.name, name.isEmpty {
            throw Abort(.badRequest, reason: "Name must not be empty")
        }
    }
    
    
}
