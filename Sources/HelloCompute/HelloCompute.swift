import Compute
import Foundation

@main
struct HelloCompute {
    static func main() async {
            await onIncomingRequest(handleIncomingRequest)
    }

    static func handleIncomingRequest(req: IncomingRequest, res: OutgoingResponse) async throws {
        print("\(req.method) \(req.url.path)\(req.url.query ?? "")")

        let fetchResponse = try await fetch(
            "https://cms-media-library.s3.us-east-1.amazonaws.com/barba/splitFile-segment-0002.mp3",
            .options(
                headers: ["range": req.headers["range"]],
                cachePolicy: .ttl(seconds: 900, staleWhileRevalidate: 900)
            )
        )

        try await res
            .status(fetchResponse.status)
            .header("accept-ranges", fetchResponse.headers["accept-ranges"])
            .header("content-type", fetchResponse.headers["content-type"])
            .header("content-length", fetchResponse.headers["content-length"])
            .header("content-range", fetchResponse.headers["content-range"])
            .header("x-service-version", Environment.Compute.serviceVersion)
            .append(fetchResponse.body)
            .end()
    }
}
