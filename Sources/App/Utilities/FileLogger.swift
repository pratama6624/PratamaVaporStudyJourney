//
//  FileLogger.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 28/02/25.
//

import Foundation
import Logging

struct FileLogger: LogHandler {
    let label: String
    let fileURL: URL
    var metadata: Logger.Metadata = [:]
    var logLevel: Logger.Level = .info
    
    init(label: String, filePath: String) {
        self.label = label
        self.fileURL = URL(fileURLWithPath: filePath)
    }
    
    subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }
    
    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
        let logEntry = "[\(Date())] [\(level)] \(message)\n"
        
        do {
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            fileHandle.seekToEndOfFile()
            if let data = logEntry.data(using: .utf8) {
                fileHandle.write(data)
            }
            fileHandle.closeFile()
        } catch {
            try? logEntry.write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }
}
