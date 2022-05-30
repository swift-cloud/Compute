# swift-compute-runtime

Swift runtime for Fastly Compute@Edge

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAndrewBarba%2Fswift-compute-runtime%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/AndrewBarba/swift-compute-runtime) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAndrewBarba%2Fswift-compute-runtime%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/AndrewBarba/swift-compute-runtime)

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
