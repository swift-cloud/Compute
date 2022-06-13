# swift-compute-runtime

Swift runtime for Fastly Compute@Edge

[![Compatibility Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAndrewBarba%2Fswift-compute-runtime%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/AndrewBarba/swift-compute-runtime) [![Platform Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAndrewBarba%2Fswift-compute-runtime%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/AndrewBarba/swift-compute-runtime)

## Getting Started

Create a new swift package using the `executable` template

```sh
swift package init --type executable
```

Install the Compute runtime:

```swift
.package(name: "Compute", url: "https://github.com/AndrewBarba/swift-compute-runtime", branch: "main")
```

## Deploy

The easiest way to deploy a Swift app to Fastly is through [Swift Cloud](https://swift.cloud).

Swift Cloud is a fully managed platform as a service for deploying SwiftWasm apps to Fastly. You can connect your Github account and deploy your apps in 1 click.

## Documentation

Complete documentation is very much a work in progress:

[https://compute-runtime.swift.cloud/documentation/compute/](https://compute-runtime.swift.cloud/documentation/compute/)

## Sample App

Here's what a Swift app looks like on Compute@Edge

```swift
import Compute

@main
struct HelloCompute {
    static func main() async throws {
        try await onIncomingRequest(handleIncomingRequest)
    }

    static func handleIncomingRequest(req: IncomingRequest, res: OutgoingResponse) async throws {
        let fetchResponse = try await fetch("https://httpbin.org/json", .options(
            headers: ["user-agent": "swift-compute-runtime"]
        ))
        let text = try await fetchResponse.text()
        try await res.status(200).send(text)
    }
}
```

## SwiftWasm

Swift on Compute@Edge is made possible by the incredible [SwiftWasm](https://swiftwasm.org) project, but probably not in the way you might think. Web Assembly is making waves as being a new high performance environment for web application development but it's also powering cloud computing platforms like Fastly Compute@Edge. Deploying to Fastly involves compiling your code to Web Assembly and then deploying it to a Fastly service. This can be accomplished via GitHub actions but the absolute easiest way to deploy your code is through [Swift Cloud](https://swift.cloud). Swift Cloud builds your code on [AWS Fargate instances](https://github.com/swift-cloud/build) and then optimizes the WASM binary using Binaryen. Fastly services are managed behind the scenes and we make it really simple to integrate things like Edge Dictionaries, Backends and environment variables.

## Routing

The Compute package incldues an Express style router based on [Vapor's routing-kit](https://github.com/vapor/routing-kit). Here are some basic ways to use the router:

### GET Route

```swift
import Compute

@main
struct App {
    static func main() async throws {
        try await onIncomingRequest(router.run)
    }

    static let router = Router()
        .get("/status") { req, res in
            try await res.status(.ok).send("OK")
        }
        .get("/user/:name") { req, res in
            let name = req.pathParams["name"] ?? ""
            let text = "Hello, \(name)!"
            try await res.status(.ok).send(text)
        }
}
```

### POST Route

```swift
import Compute

struct User: Codable {
    let name: String
}

@main
struct App {
    static func main() async throws {
        try await onIncomingRequest(router.run)
    }

    static let router = Router()
        .post("/user") { req, res in
            let user = try await req.body.decode(User.self)
            try await res.status(.created).send(user)
        }
}
```

## Fetching Data

One of the main drawbacks of WebAssembly today is no standardized way to handle sockets. Because of this SwiftWasm does not have access to some Foundation classes like URLSession. This requires each runtime to provide their own networking layer until a standardized threading and socket model is introduced into the WASM spec.

The Compute package provides the `fetch(_ url: String)` function for sending asynchronous HTTP requests. The implementation is largely modeled on the HTML5 `fetch()` spec including full support for streaming request and response bodies, async/await, and Codable support.

**Important:** In order to use `fetch` you must pre-define the hostnames that you will be calling out to. For example, if you are integrating with the Stripe API you must pre-define `api.stripe.com` in your Fastly service. Swift Cloud also makes this really easy to define all of your external origins when creating your project. We sincerely hope this is a short term limitation of the Fastly platform and believe they are working on a mechanism to call arbitrary backends without the need to pre-define them.

### GET Request

```swift
let data = try await fetch("https://httpbin.org/json").json()
```

### POST Request

```swift
let res = try await fetch("https://httpbin.org/json", .options(
    method: .post,
    body: .json(["name": "Andrew"])
))
```

### PROXY

A really powerful feature of the Compute package is the ability to proxy to another origin. Fasty's edge platform is a globally distributed CDN that provides unprecendented performance compared to a single region origin. Using Compute you can put a full featured CDN in front of your origin to do things like force HTTPS, enable HTTP/3, provide robust origin failover, and a lot more.

```swift
/// req: IncomingRequest, res: OutgoingResponse
let data = try await fetch(req, origin: "https://httpbin.org", .options(
    cachePolicy: .ttl(10, staleWhileRevalidate: 30)
))
try await res.proxy(data)
```
