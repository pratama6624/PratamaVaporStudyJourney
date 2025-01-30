//
//  IOController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 30/01/25.
//

import Vapor

struct IOController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("upload", use: self.upload)
            .withMetadata("Upload file", "IO Management")
        
        routes.get("download", use: self.download)
            .withMetadata("Download file", "IO Management")
    }
    
    // -> POST /upload
    @Sendable
    func upload(req: Request) async throws -> HTTPStatus {
        let publicPath = DirectoryConfiguration.detect().publicDirectory
        let filePath = publicPath + "Uploads/Output.txt"
        
        // Buat folder jika belum ada
        let fileManager = FileManager.default
        let uploadsFolder = publicPath + "Uploads/"
        if !fileManager.fileExists(atPath: uploadsFolder) {
            let created = fileManager.createFile(atPath: filePath, contents: nil)
            guard created else {
                throw Abort(.internalServerError, reason: "Failed to create file")
            }
        }
        
        // Buka file untuk penulisan
        guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
            throw Abort(.internalServerError, reason: "Failed to open file for writing")
        }
        
        // Streaming body ke file
        req.body.drain { part in
            switch part {
            case .buffer(let buffer):
                let data = Data(buffer: buffer)
                fileHandle.write(data)
            case .end:
                try? fileHandle.close()
            default:
                break
            }
            return req.eventLoop.makeSucceededFuture(())
        }
        
        return .ok
    }
    
    // -> GET /download
    @Sendable
    func download(req: Request) async throws -> Response {
        let publicPath = DirectoryConfiguration.detect().publicDirectory
        let filePath = publicPath + "Uploads/Output.txt"
        
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: filePath) else {
            throw Abort(.notFound, reason: "File not found")
        }
        
        let fileURL = URL(fileURLWithPath: filePath)
        return req.fileio.streamFile(at: fileURL.path)
    }
}
