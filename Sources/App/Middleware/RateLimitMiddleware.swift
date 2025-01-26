//
//  RateLimitMiddleware.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 26/01/25.
//

import Vapor

actor RateLimiter {
    private let maxRequest: Int
    private let resetInterval: TimeInterval
    private var requestCounts: [String: (count: Int, resetDate: Date)] = [:]
    
    init(maxRequest: Int, resetInterval: TimeInterval) {
        self.maxRequest = maxRequest
        self.resetInterval = resetInterval
    }
    
    func shouldAllowRequest(for ip: String) -> Bool {
        let now = Date()
        
        // Reset jika interval terlewati
        if let info = requestCounts[ip], info.resetDate <= now {
            requestCounts[ip] = nil
        }
        
        // Periksa apakah melebihi batas
        if let info = requestCounts[ip], info.count >= maxRequest {
            return false
        }
        
        if var info = requestCounts[ip] {
            info.count += 1
            requestCounts[ip] = info
        } else {
            requestCounts[ip] = (count: 1, resetDate: now.addingTimeInterval(resetInterval))
        }
        
        return true
    }
}

final class RateLimitMiddleware: Middleware {
    private let rateLimiter: RateLimiter
    
    init(maxRequest: Int, resetInterval: TimeInterval) {
        self.rateLimiter = RateLimiter(maxRequest: maxRequest, resetInterval: resetInterval)
    }
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let ip = request.remoteAddress?.description else {
            return next.respond(to: request)
        }
        
        // Gunakan EventLoopPromise untuk menangani operasi async dalam Vapor
        let promise = request.eventLoop.makePromise(of: Response.self)

        Task {
            let isAllowed = await rateLimiter.shouldAllowRequest(for: ip)
            if isAllowed {
                // Jika request diizinkan, lanjutkan ke middleware berikutnya
                next.respond(to: request).cascade(to: promise)
            } else {
                // Jika tidak diizinkan, berikan respons error
                promise.fail(Abort(.tooManyRequests, reason: "You have exceeded the maximum allowed requests."))
            }
        }

        return promise.futureResult
    }
}
