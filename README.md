# swift-compute-runtime

Swift runtime for Fastly Compute@Edge

[https://hello-swift.edgecompute.app](https://hello-swift.edgecompute.app)

## Sample App

Here's what a Swift app looks like on Compute@Edge

```swift
import Compute

@main
struct HelloCompute {
    static func main() async {
        await onIncomingRequest(handleIncomingRequest)
    }

    static func handleIncomingRequest(req: IncomingRequest, res: OutgoingResponse) async throws {
        let fetchResponse = try await fetch("https://httpbin.org/json")
        let text = try fetchResponse.body.text()
        try res.status(200).send(text)
    }
}
```
