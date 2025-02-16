# Learning Vapor: A Swift-based Backend Framework

This repository is created to document my journey in learning **Vapor**, a Swift-based backend framework. All practices, experiments, and updates will be recorded here in alignment with the official documentation and my hands-on experience.

## Road Map

### Basics
```bash
    Routing :
    
    [√] HTTP Method ( GET, POST, PUT, PATCH, DELETE, OPTION )
    [√] Request Path ( / )
    [√] Router Methods
    [√] Route Parameters ( static )
    [√] Routes
    [√] Methods
    [√] Path Component ( Constant, Parameter, Anything*, Catchall**)
    [√] Parameters ( dynamic )
    [√] Body Streaming ( upload & download )
    [√] Case Insensitive Routing
    [√] Viewing Routes debugging ( swift run App routes )
    [√] Metadata ( description & userInfo )
    [√] Route Groups ( RouteBuilder )
    [√] Path Prefix ( Variable Grouping )
    [√] Middleware ( Authentication & Authorization, Logging, CORS, Validation, Modification )
    [√] Redirections
```
```bash
    Controller :
    
    [√] Business Login & HTTP Request Handler 
```
```bash
    Content :
    
    [√] Content Encode ( Object Model -> JSON )
    [√] Content Decode ( JSON -> Object Model )
    [√] Media Types ( JSON, Multipart, URL-Encoded Form, Plaintext, HTML )
    [√] Single Value ( Sample -> /pow?number=4 )
    [√] Multiple Value ( Sample -> /tags?tag=Swift&tag=Vapor&tag=Fluent)
    [√] Hooks ( afterDecode & beforeEncode )
    [√] Override Default Global ( All -> configure.swift )
    [√] Override Default One-Off ( Specific -> Handler )
    [√] Custom Coders Content ByteBuffer Encoding ( File Image -> ByteBuffer)
    [√] Custom Coders Content ByteBuffer Decoding ( ByteBuffer -> File Image )
    [√] Custom Coders Content URL Query ( Search Data Without Regex - PostgreSQL )
    [√] Custom Coders Content URL Query ( Search Data With Regex - PostgreSQL )
    [√] Custom Coders Content URL Query ( URLQueryDecoder() -> Internal Access Level )
    [√] Custom Coders Content URL Query ( URLQueryEncoder() -> Internal Access Level )
    [√] ResponseEncodable ( EventLoopFuture -> Already Left )
    [√] ResponseEncodable ( AsyncResponseEncodable )
```
```bash
    Client
    
    [√] Client ( Open Weather API ) 
    [√] Client ( Visual Crossing Weather API )
    [√] Client Method ( GET )
    [√] Client Content ( Httpbin API Test GET )
    [√] Client Content ( Httpbin API Test POST )
    [√] Client Content ( Httpbin API Test GET With Basic AUTH )
    [√] Client Content ( Httpbin API Test GET With JSON Response )
    [√] Client Content ( Configuration )
    [√] Client Content ( Redirect or Infinite Loop )
    [√] Client Content ( Handle Infinite Loop )
```
```bash
    Validation
    
    [√] Validation HRE ( Human-Readable Errors )
    [√] Validation HRE Format Response ( AbortError Vapor Default )
    [√] Validation HRE Format Response ( Custom Format Response Middleware )
    [√] Validation ( Specific Validation )
    [√] Validation ( Validatable Protocol & Validator List )
    [ ] Validation ( Adding Validations )
```
