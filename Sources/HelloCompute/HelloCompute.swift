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