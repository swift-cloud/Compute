import Compute
import Foundation
import JWTDecode

/**
Sample URL:

https://hello-swift.edgecompute.app/stream.mp3?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MjQzMDkyMDAwMDAsImV4cCI6MTYyNDM5NTYwMDAwMCwiZGF0YSI6eyJ1IjpbImh0dHBzOi8vY21zLW1lZGlhLWxpYnJhcnkuczMudXMtZWFzdC0xLmFtYXpvbmF3cy5jb20vYmFyYmEvc3BsaXRGaWxlLXNlZ21lbnQtMDAwMC5tcDMiLCJodHRwczovL2Ntcy1tZWRpYS1saWJyYXJ5LnMzLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tL2JhcmJhL3NwbGl0RmlsZS1zZWdtZW50LTAwMDEubXAzIiwiaHR0cHM6Ly9jbXMtbWVkaWEtbGlicmFyeS5zMy51cy1lYXN0LTEuYW1hem9uYXdzLmNvbS9iYXJiYS9zcGxpdEZpbGUtc2VnbWVudC0wMDAyLm1wMyJdLCJjIjoiYXVkaW8vbXBlZyJ9fQ.hwtTWYf2aecgmveSVhPdhaEsz8A8LQax4aeXBEvtD50
**/

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
