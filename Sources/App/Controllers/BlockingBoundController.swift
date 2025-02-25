//
//  BlockingBoundController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 25/02/25.
//

import Vapor
import Fluent

struct BlockingBoundController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let blockingBound = routes.grouped("blockingboundupload")
        
        blockingBound.post("csv", use: self.uploadCSV)
            .withMetadata("Upload csv", "Blocking Bound Controller")
    }
    
    // POST Request /blockingboundupload/csv
    @Sendable
    func uploadCSV(req: Request) throws -> EventLoopFuture<Response> {
        let file: File
        
        do {
            file = try req.content.get(File.self, at: "file")
        } catch {
            throw Abort(.unsupportedMediaType)
        }
        
        // Thread pool for non blocking IO
        return req.application.threadPool.runIfActive(eventLoop: req.eventLoop) {
            return try parseCSV(file: file)
        }
        .flatMap { users in
            return users.create(on: req.db).transform(to: Response(status: .ok))
        }
    }
    
    // CSV Parsing
    func parseCSV(file: File) throws -> [UserIOBound] {
        guard let data = file.data.getData(at: 0, length: file.data.readableBytes),
              let content = String(data: data, encoding: .utf8) else {
            throw Abort(.badRequest, reason: "Invalid csv file")
        }
        
        var users: [UserIOBound] = []
        let rows = content.components(separatedBy: "\n")
        
        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: ",")
            if columns.count == 2 {
                let user = UserIOBound(
                    name: columns[0].trimmingCharacters(in: CharacterSet.whitespaces),
                    email: columns[1].description.trimmingCharacters(in: CharacterSet.whitespaces)
                )
                users.append(user)
            }
        }
        
        return users
    }
}
