//
//  EventLoopFutureController.swift
//  PratamaVaporStudyJourney
//
//  Created by Pratama One on 21/02/25.
//

import Vapor

// ELF -> Event Loop Future
struct EventLoopController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        // map test
        routes.get("eventloopfuture", "map", use: mapTest)
            .withMetadata("Test map", "ELF Controller")
        
        // flat map throwing
        routes.get("eventloopfuture", "flatmapthrowingtest", use: flatMapThrowingTest)
            .withMetadata("Test map throwing", "ELF Controller")
        
        // flat map throwing with query params
        routes.get("eventloopfuture", "flatmapthrowingwithquerytest", use: self.flatMapThrowingTestWithQueryParams)
            .withMetadata("Test map throwing with query params", "ELF Controller")
        
        // flat map test -> add 10
        routes.get("eventloopfuture", "flatmap", use: self.flatMapTest)
            .withMetadata("Test flat map", "ELF Controller")
        
        // transform test -> server health check
        routes.get("eventloopfuture", "serverhealthtest", use: self.transformTest)
            .withMetadata("Test transform", "ELF Controller")
        
        // chaining
        routes.get("eventloopfuture", "chaining", use: self.fetchDataTest)
            .withMetadata("Test chaining", "ELF Controller")
        
        // Make Future
        // makeSucceededFuture
        routes.get("eventloopfuture", "makesucceededfuture", use: self.getProduct)
            .withMetadata("Test make succeeded future", "ELF Controller")
        
        // Make Future
        // makeFailedFuture
        routes.get("eventloopfuture", "makefailedfuture", use: self.validateUUIDMakeFuture)
            .withMetadata("Test make failed future", "ELF Controller")
        
        // Make Future
        // makeSucceededFuture
        // makeFailedFuture
        routes.get("eventloopfuture", "makesucceededfailedfuture", use: self.validationUUIDMakeSucceededFailedFuture)
            .withMetadata("Test make succeeded + failed future", "ELF Controller")
        
        // When complete
        // .success & .failure
        routes.get("eventloopfuture", "whencomplete", use: self.whenCompleteTest)
            .withMetadata("Test when complete", "ELF Controller")
        
        // .get & .wait
        // Blocking IO
        // Danger -> It will block the event loop and will make the serve slow, down and even hang
        // Forbidden -> It will throw an error if the end point is called because vapor forbids the use of .get & .wait in the main event loop
        routes.get("eventloopfuture", "gettestblocking", use: self.getAndWaitTest)
            .withMetadata("Test blocking event loop .get & .wait", "ELF Controller")
        
        // Promise -> Succeed
        routes.get("eventloopfuture", "promisesucceed", use: self.getPromiseSucceed)
            .withMetadata("Test succeed promise", "ELF Controller")
    }
    
    // GET Request -> /eventloopfuture/map
    @Sendable
    func mapTest(req: Request) -> EventLoopFuture<String> {
        let eventLoop = req.eventLoop
        let futureText = eventLoop.makeSucceededFuture(("Hello, World!"))
        
        return futureText.map { text in
            return text.uppercased()
        }
    }
    
    // GET Request -> /eventloopfuture/flatmapthrowingtest
    @Sendable
    func flatMapThrowingTest(req: Request) -> EventLoopFuture<String> {
        let eventLoop = req.eventLoop
        let futureNumber = eventLoop.makeSucceededFuture(5)
        
        return futureNumber.flatMapThrowing { number in
            guard number % 2 == 0 else {
                throw Abort(.badRequest, reason: "The number must be even")
            }
            return "Valid number: \(number)"
        }
    }
    
    // GET Request -> /eventloopfuture/flatmapthrowingwithquerytest?number=7
    @Sendable
    func flatMapThrowingTestWithQueryParams(req: Request) -> EventLoopFuture<String> {
        let eventLoop = req.eventLoop
        
        return eventLoop.future().flatMapThrowing {
            guard let numberParams = try? req.query.get(Int.self, at: "number") else {
                throw Abort(.badRequest, reason: "Missing 'number' query parameter")
            }
            
            guard numberParams % 2 == 0 else {
                throw Abort(.badRequest, reason: "Number must be even")
            }
            
            return "Valid number \(numberParams)"
        }
    }
    
    // GET Request -> /eventloopfuture/flatmap
    // Add 10
    @Sendable
    func flatMapTest(req: Request) -> EventLoopFuture<Int> {
        let eventLoop = req.eventLoop
        let futureNumber = eventLoop.makeSucceededFuture(10)
        
        return futureNumber.flatMap { number in
            let newNumber = number + 10
            return eventLoop.makeSucceededFuture(newNumber)
        }
    }
    
    // GET Request -> /eventloopfuture/transform
    // transformTest -> Server health test
    @Sendable
    func transformTest(req: Request) -> EventLoopFuture<String> {
        let eventLoop = req.eventLoop
        
        let serverIsHealthyFuture = eventLoop.future(true)
        
        return serverIsHealthyFuture.transform(to: "Server is OK")
    }
    
    // GET Request -> /eventloopfuture/fetchdata?id=87860987-0318-47a2-89a9-ca8bbfbbace7
    @Sendable
    func fetchDataTest(req: Request) -> EventLoopFuture<Response> {
        let client = req.client
        let eventLoop = req.eventLoop
        
        // get from params
        guard let idString = try? req.query.get(String.self, at: "id") else {
            return eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Invalid id"))
        }
        
        // Convert id -> UUID with flat map throwing
        // Chaining
        return eventLoop.future(idString).flatMapThrowing { id in
            guard let uuid = UUID(uuidString: id) else {
                throw Abort(.badRequest, reason: "Invalid id")
            }
            
            return uuid
        }
        .flatMap { uuid in
            let url = "https://reqres.in/api/users/\(uuid.uuidString.prefix(1))"
            return client.get(URI(string: url))
        }
        .flatMapThrowing { response in
            guard let buffer = response.body,
                  let bodyString = buffer.getString(at: 0, length
                                                    : buffer.readableBytes) else {
                throw Abort(.notFound, reason: "Data not found")
            }
            
            var headers = HTTPHeaders()
            headers.add(name: .contentType, value: "appliable/json")
            
            return Response(status: .ok, headers: headers, body: .init(stringLiteral: bodyString))
        }
    }
    
    // GET Request -> /eventloopfuture/makesucceededfuture
    @Sendable
    func getProduct(req: Request) -> EventLoopFuture<[String]> {
        let eventLoop = req.eventLoop
        let products: [String] = [
            "Macbook Pro", "Iphone 16e", "Iphone 15 Pro", "Apple Watch", "Airpods Pro"
        ]
        
        return eventLoop.makeSucceededFuture(products)
    }
    
    // GET Request -> /eventloopfuture/makeFailedFuture?id=87860987-0318-47a2-89a9-ca8bbfbbace7
    @Sendable
    func validateUUIDMakeFuture(req: Request) -> EventLoopFuture<String> {
        let eventLoop = req.eventLoop
        
        guard let uuidString = try? req.query.get(String.self, at: "id"), let uuid = UUID(uuidString: uuidString) else {
            return eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Invalid ID"))
        }
        
        return eventLoop.makeSucceededFuture(uuid.uuidString)
    }
    
    // GET Request -> /eventloopfuture/makesucceededfailedfuture?id=87860987-0318-47a2-89a9-ca8bbfbbace7
    @Sendable
    func validationUUIDMakeSucceededFailedFuture(req: Request) -> EventLoopFuture<[String: String]> {
        let eventLoop = req.eventLoop
        
        // UUID parameter optional handling
        guard let uuidString = try? req.query.get(String.self, at: "id"), let uuid = UUID(uuidString: uuidString) else {
            return eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Invalid ID"))
        }
        
        // Data simulation
        let user: [String: String] = [
            "id": uuid.uuidString,
            "name": "Pratama",
            "age": "25"
        ]
        
        return eventLoop.makeSucceededFuture(user)
    }
    
    // GET Request -> /eventloopfuture/whencomplete?id=87860987-0318-47a2-89a9-ca8bbfbbace7
    @Sendable
    func whenCompleteTest(req: Request) -> EventLoopFuture<Response> {
        let eventLoop = req.eventLoop
        let client = req.client
        
        // Optional handling UUID String parameter
        guard let idString = try? req.query.get(String.self, at: "id"), let uuid = UUID(uuidString: idString) else {
            return eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Invalid ID"))
        }
        
        // Success in getting data
        let url = URI(string: "https://reqres.in/api/users/\(uuid.uuidString.prefix(1))")
        
        // Failed to get data
//        let url = URI(string: "https://example/api/users/\(uuid.uuidString.prefix(1))")
        
        // Use flat map throwing -> return Response
        let futureResponse = client.get(url).flatMapThrowing { response in
            guard let buffer = response.body, let bodyString = buffer.getString(at: 0, length: buffer.readableBytes) else {
                throw Abort(.badRequest, reason: "Data not found")
            }
            
            var headers = HTTPHeaders()
            headers.add(name: "Content-Type", value: "application/json")
            
            return Response(status: .ok, headers: headers, body: .init(stringLiteral: bodyString))
        }
        
        // Process when complete
        // Logging -> Only Terminal
        futureResponse.whenComplete { result in
            switch result {
            case .success(let response):
                print("Success: \(response.status)")
            case .failure(let error):
                print("Error: [Data Not Found] -> \(error.localizedDescription)")
            }
        }
        
        return futureResponse
    }
    
    // GET Request -> /eventloopfuture/getTestBlocking
    @Sendable
    func getAndWaitTest(req: Request) -> String {
        let eventLoop = req.eventLoop
        let futureString: EventLoopFuture<String> = getDataFromExternalAPI(eventLoop: eventLoop)
        
        return DispatchQueue.global().sync {
            let result = try? futureString.wait()
            return result ?? "No data"
        }
    }
    // Blocking get data from external API with delay 2 second
    private func getDataFromExternalAPI(eventLoop: EventLoop) -> EventLoopFuture<String> {
        let promise = eventLoop.makePromise(of: String.self)
        
        // Delay 2 second
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            promise.succeed("Data success")
        }
        
        return promise.futureResult
    }
    
    // GET Request -> /eventloopfuture/promisesucceed
    // Simulation if successful
    // Future data types
    @Sendable
    func getPromiseSucceed(req: Request) -> EventLoopFuture<String> {
        let eventLoop = req.eventLoop
        let promise = eventLoop.makePromise(of: String.self)
        
        eventLoop.scheduleTask(in: .seconds(2)) {
            promise.succeed("Data success")
        }
        
        return promise.futureResult
    }
}
