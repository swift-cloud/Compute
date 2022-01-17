import Compute
import Foundation

@main
struct HelloCompute {
    static func main() async {
        await onIncomingRequest(handleIncomingRequest)
    }

    static func handleIncomingRequest(req: IncomingRequest, res: OutgoingResponse) async throws {
        print("\(req.method) \(req.url.path) \(req.url.query ?? "")")

        let urls = [
            "https://cms-media-library.s3.us-east-1.amazonaws.com/barba/splitFile-segment-0000.mp3",
            "https://cms-media-library.s3.us-east-1.amazonaws.com/barba/splitFile-segment-0001.mp3",
            "https://cms-media-library.s3.us-east-1.amazonaws.com/barba/splitFile-segment-0002.mp3"
        ]

        let headResponses = try await urls.mapAsync {
            try await fetch($0, .options(
                method: .head,
                cachePolicy: .ttl(seconds: 900, staleWhileRevalidate: 900)
            ))
        }

        let totalContentLength = parseContentLength(headResponses)

        let range = parseRange(req, totalContentLength: totalContentLength)

        let rangeResponses = try await rangeRequests(headResponses, range: range).mapAsync { (url, range) in
            try await fetch(url, .options(
                method: .get,
                headers: ["range": "bytes=\(range.start)-\(range.end)"],
                cachePolicy: .ttl(seconds: 900, staleWhileRevalidate: 900)
            ))
        }

        let partialContentLength = parseContentLength(rangeResponses)

        let rangeValue = "bytes \(range.start)-\(range.start + partialContentLength - 1)/\(totalContentLength)"

        try await res
            .status(206)
            .header(.acceptRanges, "bytes")
            .header(.contentType, "audio/mpeg")
            .header(.contentRange, rangeValue)
            .header("x-service-version", Environment.Compute.serviceVersion)
            .append(rangeResponses.map(\.body))
            .end()
    }
}
