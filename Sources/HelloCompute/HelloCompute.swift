import Compute
import Foundation
import JWTDecode

@main
struct HelloCompute {
    static func main() async {
        await onIncomingRequest(handleIncomingRequest)
    }

    static func handleIncomingRequest(req: IncomingRequest, res: OutgoingResponse) async throws {
        print("\(req.method) \(req.url.path) \(req.url.query ?? "")")

        guard
            let token = req.searchParams["token"],
            let decoded = try? decode(jwt: token),
            let data = decoded.body["data"] as? [String: Any],
            let urls = data["u"] as? [String]
        else {
            return try await res.status(400).send("Missing pipe-stream token.")
        }

        let headResponses = try await urls.mapAsync {
            try await fetch($0, .options(
                method: .head,
                cachePolicy: .ttl(seconds: 900, staleWhileRevalidate: 900)
            ))
        }

        print(headResponses[0].headers.dictionary())

        for headResponse in headResponses {
            guard headResponse.ok else {
                return try await res.status(headResponse.status).append(headResponse.body).end()
            }
        }

        let totalContentLength = parseContentLength(headResponses)

        let range = parseRange(req, totalContentLength: totalContentLength)

        let rangeConfigs = rangeRequests(headResponses, range: range)

        let rangeResponses = try await rangeConfigs.mapAsync { (url, _range) -> FetchResponse in
            print(url)
            print("range", _range.start, _range.end)
            return try await fetch(url, .options(
                method: .get,
                headers: ["range": "bytes=\(_range.start)-\(_range.end)"],
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
