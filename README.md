# Learning Vapor: A Swift-based Backend Framework

This repository is created to document my journey in learning **Vapor**, a Swift-based backend framework. All practices, experiments, and updates will be recorded here in alignment with the official documentation and my hands-on experience.

## Road Map

### Basics
```bash
    Routing :
    
    1. HTTP Method ( GET, POST, PUT, PATCH, DELETE, OPTION )
    2. Request Path ( / )
    3. Router Methods
    4. Route Parameters ( static )
    5. Routes
    6. Methods
    7. Path Component ( Constant, Parameter, Anything*, Catchall**)
    8. Parameters ( dynamic )
    9. Body Streaming ( upload & download )
    10. Case Insensitive Routing
    11. Viewing Routes debugging ( swift run App routes )
    12. Metadata ( description & userInfo )
    13. Route Groups ( RouteBuilder )
    14. Path Prefix ( Variable Grouping )
    15. Middleware ( Authentication & Authorization, Logging, CORS, Validation, Modification )
    16. Redirections
```
```bash
    Controller :
    
    Business Login & HTTP Request Handler 
```
```bash
    Content :
    
    1. Content Encode ( Object Model -> JSON )
    2. Content Decode ( JSON -> Object Model )
    2. Media Types ( JSON, Multipart, URL-Encoded Form, Plaintext, HTML )
    3. Single Value ( Sample -> /pow?number=4 )
    4. Multiple Value ( Sample -> /tags?tag=Swift&tag=Vapor&tag=Fluent)
    5. Hooks ( afterDecode & beforeEncode )
    6. Override Default Global ( All -> configure.swift )
    7. Override Default One-Off ( Specific -> Handler )
    8. Custom Coders Content ( on gping ) -> Hello, I'm here
```
