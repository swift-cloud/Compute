import Compute

@main
struct HelloCompute {
    static func main() async {
        print("Hello, Compute.")
        await onIncomingRequest(handleIncomingRequest)
    }

    static func handleIncomingRequest(req: IncomingRequest, res: OutgoingResponse) async throws {
        print("env:hostname", Environment.Compute.hostname)
        print("env:region", Environment.Compute.region)
        print("env:service_id", Environment.Compute.serviceId)
        print("env:service_version", Environment.Compute.serviceVersion)

        print("req:method", req.method)
        print("req:uri", req.url)
        print("req:version", req.httpVersion)

        let fetchResponse = try await fetch("https://httpbin.org/json")
        print("fetch:status", try fetchResponse.response.status())
        print("fetch:content-type", try fetchResponse.headers.get("content-type") ?? "(null)")
        print("fetch:content-length", try fetchResponse.headers.get("content-length") ?? "(null)")
        print("fetch:server", try fetchResponse.headers.get("server") ?? "(null)")

        let data = try fetchResponse.body.readData(size: 1024 * 100)
        print("fetch:body", String(data: data, encoding: .utf8) ?? "(null)")

        guard let ip = req.clientIp else {
            try res.status(400).send("Count not parse IP Address.")
            return
        }

        print("client:ip", ip)

        let ipLookup = try Geo.lookup(ip: ip)

        try res.status(200).send(ipLookup)
    }
}

public struct StatusResponse: Codable {
    public let status: String
}
