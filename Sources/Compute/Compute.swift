//
//  Compute.swift
//
//
//  Created by Andrew Barba on 1/11/22.
//

@_exported import Foundation

#if canImport(FoundationNetworking)
    @_exported import FoundationNetworking
#endif

@MainActor
public func onIncomingRequest(
    _ handler: @escaping (_ req: IncomingRequest, _ res: OutgoingResponse) async throws -> Void
) async throws {
    // Initialize ABI
    try Fastly.ABI.initialize()

    // Get downstream request
    let req = try IncomingRequest()

    // Create downstream response
    let res = try OutgoingResponse(writableBody: req.method != .head)

    do {
        // Check for special compute request, useful for pre-warming
        if isComputeStatusRequest(req) {
            return try await sendComputeStatusResponse(res)
        }

        // Run main handler
        try await handler(req, res)
    } catch {
        // Catch handler error by returning a 500
        console.error("onIncomingRequest: \(req.url.path)\n\(error.localizedDescription)")
        try await res.status(500).send("Internal Server error:\n\n\(error.localizedDescription)")
    }
}

private let computeStatusRequestMethods: Set<HTTPMethod> = [.get, .head, .options, .query]

private let computeStatusPath = "/__compute-status"

private func isComputeStatusRequest(_ req: IncomingRequest) -> Bool {
    return computeStatusRequestMethods.contains(req.method) && req.url.path == computeStatusPath
}

private func sendComputeStatusResponse(_ res: OutgoingResponse) async throws {
    try await res
        .status(204)
        .header("x-compute-service-id", Fastly.Environment.serviceId)
        .header("x-compute-service-version", Fastly.Environment.serviceVersion)
        .header("x-compute-trace-id", Fastly.Environment.traceId)
        .header("x-compute-hostname", Fastly.Environment.hostname)
        .header("x-compute-region", Fastly.Environment.region)
        .header("x-compute-pop", Fastly.Environment.pop)
        .send()
}
