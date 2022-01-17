import Compute
import Foundation

@main
struct HelloCompute {
    static func main() async {
            await onIncomingRequest(handleIncomingRequest)
    }

    static func handleIncomingRequest(req: IncomingRequest, res: OutgoingResponse) async throws {
        print("\(req.method) \(req.url.path)\(req.url.query ?? "")")

        let file0 = try await fetch(
            "https://cms-media-library.s3.us-east-1.amazonaws.com/barba/splitFile-segment-0000.mp3",
            .options(cachePolicy: .ttl(seconds: 900, staleWhileRevalidate: 900))
        )

        let file1 = try await fetch(
            "https://cms-media-library.s3.us-east-1.amazonaws.com/barba/splitFile-segment-0001.mp3",
            .options(cachePolicy: .ttl(seconds: 900, staleWhileRevalidate: 900))
        )

        let file2 = try await fetch(
            "https://cms-media-library.s3.us-east-1.amazonaws.com/barba/splitFile-segment-0002.mp3",
            .options(cachePolicy: .ttl(seconds: 900, staleWhileRevalidate: 900))
        )

        try await res
            .status(200)
            .header("accept-ranges", "none")
            .header("content-type", file0.headers["content-type"])
            .header("x-service-version", Environment.Compute.serviceVersion)
            .append(file0.body)
            .append(file1.body)
            .append(file2.body)
            .end()
    }
}
