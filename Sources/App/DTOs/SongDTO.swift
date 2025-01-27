//
//  SongDTO.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 27/01/25.
//

import Vapor
import Fluent

struct SongDTO: Content {
    var id: UUID?
    var title: String?
    
    func toModel() -> Song {
        // Buat object model Song
        let model = Song()
        
        // Pindahkan object SongDTO ke model Song
        model.id = self.id
        
        // Optional Handling
        if let title = self.title {
            model.title = title
        }
        
        // Kembalikan object model Song
        return model
    }
}
