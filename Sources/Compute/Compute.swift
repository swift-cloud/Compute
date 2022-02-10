//
//  Compute.swift
//
//
//  Created by Andrew Barba on 1/11/22.
//

public func onIncomingRequest(_ handler: @escaping (_ req: IncomingRequest, _ res: OutgoingResponse) async throws -> Void) async throws {
    let req = try IncomingRequest()
    let res = try OutgoingResponse()
    do {
        if isComputeStatusRequest(req) {
            return try await sendComputeStatusResponse(res)
        }
        try await handler(req, res)
    } catch {
        print("onIncomingRequest:error", error.localizedDescription)
        try await res.status(500).send("Server error: \(error.localizedDescription)")
    }
}

private func isComputeStatusRequest(_ req: IncomingRequest) -> Bool {
    return req.method == .get && req.url.path == "/__compute-status"
}

private func sendComputeStatusResponse(_ res: OutgoingResponse) async throws {
    try await res
        .status(204)
        .header("x-compute-service-id", Environment.Compute.serviceId)
        .header("x-compute-service-version", Environment.Compute.serviceVersion)
        .header("x-compute-trace-id", Environment.Compute.traceId)
        .send()
}
