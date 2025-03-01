//
//  BlockingBoundController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 25/02/25.
//

import Vapor
import Fluent
import PDFKit

struct BlockingBoundController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let blockingBound = routes.grouped("blockingboundupload")
        
        // POST Request /blockingboundupload/csv
        // Save CSV data to database (Postgre Sql)
        blockingBound.post("csv", use: self.uploadCSV)
            .withMetadata("Upload csv", "Blocking Bound Controller")
        
        // POST Request /blockingboundupload/generatepdf
        // Generate PDF file from CSV file
        blockingBound.post("generatepdf", use: self.generatePDF)
            .withMetadata("Make pdf from csv", "Blocking Bound Controller")
        
        // POST Request /blockingboundupload/cpuwithboundtest
        // Test cpu with bound -> blocking event loop
        blockingBound.post("cpuwithboundtest", use: self.createUserPostgre)
            .withMetadata("CPU bound test", "Blocking Bound Controller")
        
        // POST Request /blockingboundupload/cpuwithoutboundtest
        // Test cpu without bound -> non blocking event loop
        blockingBound.post("cpuwithoutboundtest", use: self.createUserPostgreNonBlocking)
            .withMetadata("CPU bound test", "Blocking Bound Controller")
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
    
    // CSV -> PDF
    @Sendable
    func generatePDF(req: Request) async throws -> Response {
        let file: File
        
        do {
            file = try req.content.get(File.self, at: "file")
        } catch {
            throw Abort(.unsupportedMediaType)
        }
        
        let users = try parseCSV(file: file)
        
        let pdfData = try await createPDF(users: users)
        
        let headers = HTTPHeaders([
            ("Content-Type", "application/pdf"),
            ("Content-Disposition", "attachment; filename=\"users.pdf\"")
        ])
        
        return Response(status: .ok, headers: headers, body: .init(data: pdfData))
    }
     
    func createPDF(users: [UserIOBound]) async throws -> Data {
        let pageBounds = CGRect(x: 0, y: 0, width: 612, height: 792)

        let pdfData = await MainActor.run {
            let textView = NSTextView(frame: pageBounds)
            textView.font = NSFont.systemFont(ofSize: 16)

            var content = ""
            for user in users {
                content += "\(user.name) - \(user.email)\n"
            }
            textView.string = content

            return textView.dataWithPDF(inside: textView.bounds)
        }
        
        let savePath = DirectoryConfiguration.detect().publicDirectory + "File/Pdf/"
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: savePath) {
            try fileManager.createDirectory(atPath: savePath, withIntermediateDirectories: true, attributes: nil)
        }
        
        let filePath = savePath + "users.pdf"
        
        try pdfData.write(to: URL(fileURLWithPath: filePath))
        
        return pdfData
    }
    
    // CPU Bound
    // POST Request
    // CPU Blocking Bound
    @Sendable
    func createUserPostgre(req: Request) throws -> EventLoopFuture<UserPostgreDTO> {
        let userpostgre = try req.content.decode(UserPostgre.self)
        userpostgre.created_at = Date()
        
        // Blocking Event
        userpostgre.password = try Bcrypt.hash(userpostgre.password)
        
        return userpostgre.save(on: req.db).map { userpostgre.toUserPostgreeDTO() }
    }
    
    // CPU Bound
    // POST Request
    // CPU Non Blocking Bound
    @Sendable
    func createUserPostgreNonBlocking(req: Request) throws -> EventLoopFuture<UserPostgreDTO> {
        let userpostgre = try req.content.decode(UserPostgre.self)
        userpostgre.created_at = Date()
        
        return req.eventLoop.future().flatMapThrowing {
            try Bcrypt.hash(userpostgre.password)
        }.flatMap { userHash in
            userpostgre.password = userHash
            return userpostgre.save(on: req.db).map {
                userpostgre.toUserPostgreeDTO()
            }
        }
    }
}
