# swift-compute-runtime

Swift runtime for Fastly Compute@Edge

## Getting Started

Create a new swift package using the `executable` template

```sh
swift package init --type executable
```

Install the Compute runtime:

```swift
.package(name: "Compute", url: "https://github.com/AndrewBarba/swift-compute-runtime", branch: "main")
```

## Documentation

Complete documentation is very much a work in progress:

[https://compute-runtime.swift.cloud](https://compute-runtime.swift.cloud)

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
